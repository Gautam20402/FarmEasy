part of 'landing_bloc.dart';

@immutable
abstract class LandingState {}

abstract class LandingActionState extends LandingState {}

class LandingInitial extends LandingState {}

class LandingNavToLoginState extends LandingActionState {}

class LandingNavToSignupState extends LandingActionState {}
