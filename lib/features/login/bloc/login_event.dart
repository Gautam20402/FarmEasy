part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonClickedEvent extends LoginEvent {}

class LoginForgotClickedEvent extends LoginEvent {}

class LoginToSignupClickedEvent extends LoginEvent {}
