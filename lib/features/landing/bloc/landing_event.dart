part of 'landing_bloc.dart';

@immutable
abstract class LandingEvent {}

class LandingInitialEvent extends LandingEvent {}

class LandingLoginClickedEvent extends LandingEvent {}

class LandingSignupClickedEvent extends LandingEvent {}
