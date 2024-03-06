import 'dart:async';

import 'package:farmeasy/features/splash/bloc/splash_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<User?> user;
  @override
  void initState() {
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        splashBloc.add(SplashLogOutEvent());
      } else {
        splashBloc.add(SplashLogInEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  final SplashBloc splashBloc = SplashBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      bloc: splashBloc,
      listenWhen: (previous, current) => current is SplashActionState,
      buildWhen: (previous, current) => current is! SplashActionState,
      listener: (context, state) {
        if (state is SplashNavToLandingScreenActionState) {
          Navigator.of(context).pushReplacementNamed("/landing");
        } else if (state is SplashNavToWeatherActionState) {
          Navigator.pushReplacementNamed(context, "/weather");
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case SplashWaitingActionState:
            return Scaffold(
              body: Center(
                child: Image.asset("assets/farmeasy-logo-nobg.png"),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
