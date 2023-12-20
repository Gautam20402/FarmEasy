import 'dart:async';

import 'package:farmeasy/features/email_verification/bloc/email_verification_bloc.dart';
import 'package:farmeasy/features/weather/ui/weather_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../login/ui/login_screen.dart';

class EmailVerficationScreen extends StatefulWidget {
  const EmailVerficationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerficationScreen> createState() => _EmailVerficationScreenState();
}

class _EmailVerficationScreenState extends State<EmailVerficationScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final EmailVerificationBloc emailVerificationBloc = EmailVerificationBloc();

  @override
  void initState() {
    emailVerificationBloc.add(EmailVerificationInitialEvent());
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      emailVerificationBloc.add(EmailVerificationDoneEvent());
      Fluttertoast.showToast(msg: "Email Successfully Verified");
      timer?.cancel();
    }
  }

  sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
      bloc: emailVerificationBloc,
      listenWhen: (previous, current) =>
          current is EmailVerificationActionState,
      buildWhen: (previous, current) =>
          current is! EmailVerificationActionState,
      listener: (context, state) {
        if (state is EmailVerificationDoneActionState) {
          Navigator.pushReplacementNamed(context, "/weather");
        } else if (state is EmailVerificationNavToLandingScreenActionState) {
          Navigator.pushReplacementNamed(context, "/landing");
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case EmailVerificationInitial:
            return SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 35),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          'Check your \n Email',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Center(
                          child: Text(
                            'We have sent you a Email on  ${FirebaseAuth.instance.currentUser?.email}\n \n Please check spam folder if mail isn\'t in your inbox',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Center(
                          child: Text(
                            'Verifying email....',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 57),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: ElevatedButton(
                          child: Text(
                            'Resend',
                            style: GoogleFonts.poppins(),
                          ),
                          onPressed: () async {
                            sendVerificationEmail();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: ElevatedButton(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(),
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            emailVerificationBloc.add(
                                EmailVerificationCancelButtonClickedEvent());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
