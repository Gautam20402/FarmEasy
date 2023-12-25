import 'package:farmeasy/const.dart';
import 'package:farmeasy/features/crop_price/ui/crop_price_show_screen.dart';
import 'package:farmeasy/features/market/ui/market_screen.dart';
import 'package:farmeasy/features/weather/ui/weather_screen.dart';
import 'package:farmeasy/localization/bloc/app_config_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/forgot_password/ui/forgot_password_screen.dart';
import 'features/signup/ui/signup_screen.dart';
import 'features/splash/ui/splash_screen.dart';
import 'features/login/ui/login_screen.dart';
import 'features/landing/ui/landing_screen.dart';
import 'features/email_verification/ui/email_verification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'localization/l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppConfigCubit()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          locale: context.watch<AppConfigCubit>().state.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: 'FarmEasy',
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              background: CustomColors.backgroundColor,
              onBackground: CustomColors.textColor,
              primary: CustomColors.primaryColor,
              onPrimary: CustomColors.primaryFgColor,
              secondary: CustomColors.secondaryColor,
              onSecondary: CustomColors.secondaryFgColor,
              tertiary: CustomColors.accentColor,
              onTertiary: CustomColors.accentFgColor,
              surface: CustomColors.backgroundColor,
              onSurface: CustomColors.textColor,
              error: Brightness.light == Brightness.light
                  ? const Color(0xffB3261E)
                  : const Color(0xffF2B8B5),
              onError: Brightness.light == Brightness.light
                  ? const Color(0xffFFFFFF)
                  : const Color(0xff601410),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ),
            useMaterial3: true,
          ),
          initialRoute: "/",
          routes: {
            '/': (context) => const SplashScreen(),
            '/landing': (context) => const LandingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/email': (context) => const EmailVerficationScreen(),
            '/forgot': (context) => const ForgotPasswordScreen(),
            '/weather': (context) => const WeatherScreen(),
            '/cropPrice': (context) => const CropPriceShowScreen(),
            '/market': (context) => const MarketScreen(),
            // '/weather': (context) => const WeatherScreen(),
          },
        );
      }),
    );
  }
}
