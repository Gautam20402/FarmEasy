import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmeasy/features/signup/bloc/signup_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '../../../const.dart';
import '../../../models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    signupBloc.add(SignupInitialEvent());
    super.initState();
  }

  final SignupBloc signupBloc = SignupBloc();
  final _auth = FirebaseAuth.instance;

  final _signupformKey = GlobalKey<FormState>();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final emailField = TextFormField(
      style: TextStyle(color: Colors.white),
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Email.";
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter Valid Email");
        }
        //reg expression for validation of domain
        // if (!RegExp("\b*.com\$", caseSensitive: true).hasMatch(value)) {
        //   return ("Enter Valid Email");
        // }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "${AppLocalizations.of(context)?.email}",
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon:
            Icon(CupertinoIcons.mail_solid, color: CustomColors.primaryColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "${AppLocalizations.of(context)?.email}",
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final passwordField = TextFormField(
      style: TextStyle(color: Colors.white),
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{8,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Please enter valid password.");
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "${AppLocalizations.of(context)?.password}",
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon:
            Icon(CupertinoIcons.lock_fill, color: CustomColors.primaryColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "${AppLocalizations.of(context)?.password}",
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final signupButton = MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 10,
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      height: 60,
      minWidth: width * 0.65,
      color: CustomColors.primaryColor,
      splashColor: Colors.green,
      onPressed: () {
        signUp(emailEditingController.text, passwordEditingController.text);
      },
      child: Text(
        "${AppLocalizations.of(context)?.signup}",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
    return BlocConsumer<SignupBloc, SignupState>(
      bloc: signupBloc,
      listenWhen: (previous, current) => current is SignupActionState,
      buildWhen: (previous, current) => current is! SignupActionState,
      listener: (context, state) {
        if (state is SignupNavToEmailVerificationState) {
          Navigator.pushReplacementNamed(context, "/email");
        } else if (state is SignupNavToLoginState) {
          Navigator.pushReplacementNamed(context, "/login");
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case SignupInitial:
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Lottie.asset(
                        "assets/farm-black.json",
                        fit: BoxFit.cover,
                        backgroundLoading: true,
                        animate: true,
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Form(
                        key: _signupformKey,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 96, left: 40, right: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)?.signup}",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 64),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  emailField,
                                  const SizedBox(height: 45),
                                  passwordField,
                                  const SizedBox(height: 30),
                                  signupButton,
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: width * 0.5,
                                        child: Text(
                                          "${AppLocalizations.of(context)?.alreadyAccount}",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                            "${AppLocalizations.of(context)?.login}",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color:
                                                    CustomColors.primaryColor,
                                              ),
                                            )),
                                        onPressed: () {
                                          signupBloc
                                              .add(SignupToLoginClickedEvent());
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  void signUp(String email, String password) async {
    _signupformKey.currentState!.validate();
    if (_signupformKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :)");

    signupBloc.add(SignupButtonClickedEvent());
  }
}
