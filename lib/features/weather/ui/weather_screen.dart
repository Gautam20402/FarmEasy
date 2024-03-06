import 'dart:async';

import 'package:farmeasy/features/landing/ui/landing_screen.dart';
import 'package:farmeasy/features/weather/bloc/weather_bloc.dart';
import 'package:farmeasy/features/weather/ui/full_weather_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:translator/translator.dart';
import 'package:weather/weather.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../localization/bloc/app_config_cubit.dart';
import '../../../localization/l10n/l10n.dart';

import '../../../const.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double? lat;
  double? long;
  var _areaName;
  var _weatherDisc;
  late WeatherFactory ws;
  late bool isDoneLoading;
  Weather? _weather;
  List<Weather> _current = [];
  List<Weather> _fiveday = [];
  Timer? timer;
  final WeatherBloc weatherBloc = WeatherBloc();
  final translator = GoogleTranslator();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  // geolocator
  String locationMessage = "";

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location is Disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission == await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission is denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission is permanently denied");
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude;
      long = position.longitude;
      setState(() {
        locationMessage = "Latitude : $lat , Longitude : $long";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    weatherBloc.add(WeatherLoadingEvent());
    ws = WeatherFactory("5207946dd56b77ee794b316d64056e21");
    if (lat == null || _areaName == null || _weatherDisc == null) {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => getAllInfo(),
      );
    }
  }

  Future<void> getAllInfo() async {
    //location
    _getCurrentLocation().then((value) {
      lat = value.latitude;
      long = value.longitude;
      // setState(() {
      //   locationMessage = "Latitude : $lat , Longitude : $long";
      // });
    });

    _liveLocation();

    //weather
    Weather w = await ws.currentWeatherByLocation(lat!, long!);
    List<Weather> forecast = await ws.fiveDayForecastByLocation(lat!, long!);
    setState(() {
      _current = [w];
      _fiveday = forecast;
      _weather = w;
    });
    translator.baseUrl = "translate.google.co.in";
    translator
        .translate(_weather!.areaName.toString(), from: 'en', to: 'hi')
        .then((result) {
      setState(() {
        _areaName = result.toString();
      });
    });
    translator
        .translate(_weather!.weatherDescription.toString(),
            from: 'en', to: 'hi')
        .then((result) {
      setState(() {
        _weatherDisc = result.toString();
      });
    });
    if (lat != null && _areaName != null && _weatherDisc != null) {
      setState(() {
        timer?.cancel();
        weatherBloc.add(WeatherReadyEvent());
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    List<String> drawerTitles = [
      'Crop Prices',
      'Market',
      'Feed',
      'Chat',
      'Logout'
    ];
    List<IconData> drawerIcons = [
      Icons.request_quote,
      Icons.storefront_rounded,
      Icons.newspaper,
      Icons.smart_toy,
      Icons.logout_outlined
    ];
    List<String> routes = [
      '/guide',
      '/competition',
      '/donate',
      '/vendor',
      'null'
    ];

    return BlocConsumer<WeatherBloc, WeatherState>(
      bloc: weatherBloc,
      listenWhen: (previous, current) => current is WeatherActionState,
      buildWhen: (previous, current) => current is! WeatherActionState,
      listener: (context, state) {
        // if (state is EmailVerificationDoneActionState) {
        //   Navigator.pushReplacementNamed(context, "/weather");
        // } else if (state is EmailVerificationNavToLandingScreenActionState) {
        //   Navigator.pushReplacementNamed(context, "/landing");
        // }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case WeatherLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case WeatherReadyState:
            return Scaffold(
              endDrawerEnableOpenDragGesture: true,
              drawerScrimColor: Colors.black87,
              extendBodyBehindAppBar: true,
              endDrawer: Drawer(
                backgroundColor: CustomColors.primaryColor,
                child: Center(
                  child: ListView.builder(
                      itemCount: drawerTitles.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          left: width * 0.09,
                          right: width * 0.04,
                          bottom: width * 0.75),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            drawerIcons[index],
                            color: Colors.white,
                          ),
                          title: Text(
                            drawerTitles[index],
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () => routes[index] == 'null'
                              ? logout(context)
                              : Navigator.pushNamed(context, routes[index]),
                        );
                      }),
                ),
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                leading: PopupMenuButton(
                  icon: const Icon(
                    Icons.language,
                    color: Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 1,
                  position: PopupMenuPosition.under,
                  itemBuilder: (_) {
                    return AppLocalizations.supportedLocales.map(
                      (locale) {
                        return PopupMenuItem<String>(
                          value: locale.languageCode,
                          child: Text(L10n.languageName(locale.languageCode)),
                          onTap: () => setState(() {}),
                        );
                      },
                    ).toList();
                  },
                  onSelected: (value) {
                    context
                        .read<AppConfigCubit>()
                        .changeLanguage(Locale(value));
                  },
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  getAllInfo();
                },
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    double myHeight = MediaQuery.of(context).size.height;
                    double myWidth = MediaQuery.of(context).size.width;
                    String lanCode =
                        (context.watch<AppConfigCubit>().state.currentLocale)
                            .toString();
                    return Center(
                      child: SizedBox(
                        height: myHeight,
                        width: myWidth,
                        child: Column(
                          children: [
                            SizedBox(
                              height: myHeight * 0.03,
                            ),
                            Text(
                              lanCode == 'hi'
                                  ? _areaName.toString()
                                  : "${_weather?.areaName.toString()}",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              _weather!.date.toString(),
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: myHeight * 0.05,
                            ),
                            Container(
                              height: myHeight * 0.05,
                              width: myWidth * 0.6,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade300,
                                      CustomColors.primaryColor,
                                      Colors.green.shade300,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    lanCode == 'hi'
                                        ? _weatherDisc
                                        : "${_weather?.weatherDescription.toString()}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: myHeight * 0.05,
                            ),
                            Image.network(
                              "https://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png",
                              height: myHeight * 0.3,
                              width: myWidth * 0.8,
                            ),
                            SizedBox(
                              height: myHeight * 0.05,
                            ),
                            SizedBox(
                              height: myHeight * 0.08,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(context)?.temp}",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _weather!.temperature.toString(),
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(context)?.wind}",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${(_fiveday[index].windSpeed! * 1.853184).toStringAsFixed(2)} km/h",
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                            "${AppLocalizations.of(context)?.humidity}",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _weather!.humidity.toString(),
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: myHeight * 0.04,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: myWidth * 0.06),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)?.nextForecast}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FullWeatherScreen(
                                                    weather: _weather!,
                                                    forecast: _fiveday,
                                                    weatherDisc: _weatherDisc,
                                                    lanCode: lanCode,
                                                  )));
                                    },
                                    child: Text(
                                      "${AppLocalizations.of(context)?.viewFull}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: CustomColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: myHeight * 0.02,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: myWidth * 0.03,
                                    bottom: myHeight * 0.03),
                                child: ScrollablePositionedList.builder(
                                  itemScrollController: itemScrollController,
                                  itemPositionsListener: itemPositionsListener,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _fiveday.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: myWidth * 0.02,
                                          vertical: myHeight * 0.01),
                                      child: Container(
                                        width: myWidth * 0.6,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // color: index == 0
                                          //     ? null
                                          //     : Colors.grey.withOpacity(0.4),
                                          gradient: index == 0
                                              ? LinearGradient(colors: [
                                                  CustomColors.primaryColor,
                                                  Colors.green.shade300,
                                                ])
                                              : LinearGradient(colors: [
                                                  Colors.grey.withOpacity(0.35),
                                                  Colors.grey.shade100,
                                                ]),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                "https://openweathermap.org/img/wn/${_fiveday[index].weatherIcon}@2x.png",
                                                height: myHeight * 0.06,
                                              ),
                                              SizedBox(
                                                width: myWidth * 0.04,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _fiveday[index]
                                                        .date
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: index == 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    _fiveday[index]
                                                        .temperature
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: index == 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingScreen()));
  }
}
