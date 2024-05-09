import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:weather/weather.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../const.dart';

class FullWeatherScreen extends StatefulWidget {
  FullWeatherScreen({
    super.key,
    required this.weather,
    required this.forecast,
    required this.weatherDisc,
    required this.lanCode,
    required this.colorCode,
  });
  final Weather weather;
  List<Weather> forecast;
  var weatherDisc;
  String lanCode;
  final int colorCode;
  @override
  State<FullWeatherScreen> createState() => _FullWeatherScreenState();
}

class _FullWeatherScreenState extends State<FullWeatherScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final Color shuffleColor =
        Colors.primaries[(widget.colorCode) % Colors.primaries.length];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: myWidth * 0.03,
            ),
            child: Column(
              children: [
                SizedBox(height: myHeight * 0.08),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: myWidth * 0.02, vertical: myHeight * 0.01),
                  child: Container(
                    height: myHeight * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(colors: [
                          shuffleColor,
                          shuffleColor.withOpacity(0.4),
                        ])),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(
                            "https://openweathermap.org/img/wn/${widget.weather.weatherIcon}@4x.png",
                            height: myHeight * 0.12,
                          ),
                          SizedBox(
                            width: myWidth * 0.04,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)?.currentWeather}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.lanCode == 'hi'
                                    ? widget.weatherDisc
                                    : "${widget.weather?.weatherDescription.toString()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.weather.temperature.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.windSpeed} : ${(widget.weather.windSpeed! * 1.853184).toStringAsFixed(2)} km/h",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.humidity} : ${widget.weather.humidity.toString()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.tempMin} : ${widget.weather.tempMin.toString()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.tempMax} : ${widget.weather.tempMax.toString()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.feelLike} ${widget.weather.tempFeelsLike.toString()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.cloudiness} : ${widget.weather.cloudiness.toString()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)?.pressure} : ${widget.weather.pressure.toString()} mb",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.forecast.length,
                  itemBuilder: (context, index) {
                    final Color color = Colors.primaries[
                        (widget.colorCode + index + 1) %
                            Colors.primaries.length];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.02,
                          vertical: myHeight * 0.01),
                      child: Container(
                        height: myHeight * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(colors: [
                              color,
                              color.withOpacity(0.4),
                            ])),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                "https://openweathermap.org/img/wn/${widget.forecast[index].weatherIcon}@4x.png",
                                height: myHeight * 0.12,
                              ),
                              SizedBox(
                                width: myWidth * 0.04,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.forecast[index].date.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    widget.lanCode == 'hi'
                                        ? widget.weatherDisc
                                        : "${widget.weather?.weatherDescription.toString()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    widget.forecast[index].temperature
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.windSpeed} : ${(widget.weather.windSpeed! * 1.853184).toStringAsFixed(2)} km/h",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.humidity} : ${widget.forecast[index].humidity.toString()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.tempMin} : ${widget.forecast[index].tempMin.toString()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.tempMax} : ${widget.forecast[index].tempMax.toString()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.feelLike} ${widget.forecast[index].tempFeelsLike.toString()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.cloudiness} : ${widget.forecast[index].cloudiness.toString()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.pressure} : ${widget.forecast[index].pressure.toString()} mb",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
