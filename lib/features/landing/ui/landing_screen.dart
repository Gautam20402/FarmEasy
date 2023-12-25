import 'package:farmeasy/features/landing/bloc/landing_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../localization/bloc/app_config_cubit.dart';
import '../../../localization/l10n/l10n.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    landingBloc.add(LandingInitialEvent());
    super.initState();
  }

  final LandingBloc landingBloc = LandingBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingBloc, LandingState>(
      bloc: landingBloc,
      listenWhen: (previous, current) => current is LandingActionState,
      buildWhen: (previous, current) => current is! LandingActionState,
      listener: (context, state) {
        if (state is LandingNavToLoginState) {
          Navigator.of(context).pushNamed("/login");
        } else if (state is LandingNavToSignupState) {
          Navigator.of(context).pushNamed("/signup");
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case LandingInitial:
            return Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  actions: [
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.language,
                        color: Colors.white,
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
                              child:
                                  Text(L10n.languageName(locale.languageCode)),
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
                  ],
                ),
                body: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Image.asset("assets/landing_image.png",
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.5),
                          colorBlendMode: BlendMode.multiply),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 96, left: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)?.hello} Welcome to ",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "FarmEasy",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.greenAccent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 40, top: 140),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                                const Center(
                                  child: Text(
                                    "Start with",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      landingBloc
                                          .add(LandingSignupClickedEvent());
                                    },
                                    child: const SizedBox(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        "SignUp",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      landingBloc
                                          .add(LandingLoginClickedEvent());
                                    },
                                    child: const SizedBox(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ));
          default:
            return const SizedBox();
        }
      },
    );
  }
}
