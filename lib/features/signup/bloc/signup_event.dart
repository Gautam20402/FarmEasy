part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupInitialEvent extends SignupEvent {}

class SignupButtonClickedEvent extends SignupEvent {}

class SignupToLoginClickedEvent extends SignupEvent {}
