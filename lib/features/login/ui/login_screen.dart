import 'package:farmeasy/features/login/bloc/login_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:farmeasy/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    loginBloc.add(LoginInitialEvent());
    super.initState();
  }

  final LoginBloc loginBloc = LoginBloc();

  final _auth = FirebaseAuth.instance;
  final _loginformkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        _loginformkey.currentState!.validate();
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "${AppLocalizations.of(context)?.email}",
        labelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon:
            const Icon(CupertinoIcons.mail_solid, color: Color(0xFF023047)),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "${AppLocalizations.of(context)?.email}",
        hintStyle:
            GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
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
        _loginformkey.currentState!.validate();
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "${AppLocalizations.of(context)?.password}",
        labelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon:
            const Icon(CupertinoIcons.lock_fill, color: Color(0xFF023047)),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "${AppLocalizations.of(context)?.password}",
        hintStyle:
            GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final loginButton = MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 10,
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      height: 60,
      minWidth: width * 0.65,
      color: CustomColors.primaryColor,
      splashColor: Colors.green,
      onPressed: () {
        logIn(emailController.text, passwordController.text);
      },
      child: Text(
        "${AppLocalizations.of(context)?.login}",
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

    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginNavToEmailVerificationState) {
          Navigator.pushReplacementNamed(context, "/email");
        } else if (state is LoginNavToSignupState) {
          Navigator.pushNamed(context, "/signup");
        } else if (state is LoginNavToForgotPassState) {
          Navigator.pushNamed(context, "/forgot");
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case LoginInitial:
            return Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Form(
                    key: _loginformkey,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 96, left: 40, right: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)?.login}",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
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
                              TextButton(
                                child: Text(
                                  "${AppLocalizations.of(context)?.forgotPassword}",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                ),
                                onPressed: () =>
                                    loginBloc.add(LoginForgotClickedEvent()),
                              ),
                              const SizedBox(height: 4),
                              loginButton,
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${AppLocalizations.of(context)?.donotHaveAcc}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    child: Text(
                                        "${AppLocalizations.of(context)?.signup}",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: CustomColors.primaryColor,
                                          ),
                                        )),
                                    onPressed: () => loginBloc
                                        .add(LoginToSignupClickedEvent()),
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
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  void logIn(String email, String password) async {
    if (_loginformkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                loginBloc.add(LoginButtonClickedEvent()),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
