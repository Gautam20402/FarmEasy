part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class LoginNavToEmailVerificationState extends LoginActionState {}

class LoginNavToSignupState extends LoginActionState {}

class LoginNavToForgotPassState extends LoginActionState {}
