part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

abstract class SignupActionState extends SignupState {}

class SignupInitial extends SignupState {}

class SignupNavToEmailVerificationState extends SignupActionState {}

class SignupNavToLoginState extends SignupActionState {}
