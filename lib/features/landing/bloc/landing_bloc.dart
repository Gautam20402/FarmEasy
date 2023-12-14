import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(LandingInitial()) {
    on<LandingInitialEvent>(landingInitialEvent);
    on<LandingLoginClickedEvent>(landingLoginClickedEvent);
    on<LandingSignupClickedEvent>(landingSignupClickedEvent);
  }
  FutureOr<void> landingInitialEvent(
      LandingInitialEvent event, Emitter<LandingState> emit) {
    emit(LandingInitial());
  }

  FutureOr<void> landingLoginClickedEvent(
      LandingLoginClickedEvent event, Emitter<LandingState> emit) {
    emit(LandingNavToLoginState());
  }

  FutureOr<void> landingSignupClickedEvent(
      LandingSignupClickedEvent event, Emitter<LandingState> emit) {
    emit(LandingNavToSignupState());
  }
}
