import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupInitialEvent>(signupInitialEvent);
    on<SignupButtonClickedEvent>(signupButtonClickedEvent);
    on<SignupToLoginClickedEvent>(signupToLoginClickedEvent);
  }

  FutureOr<void> signupInitialEvent(
      SignupInitialEvent event, Emitter<SignupState> emit) {
    emit(SignupInitial());
  }

  FutureOr<void> signupButtonClickedEvent(
      SignupButtonClickedEvent event, Emitter<SignupState> emit) {
    emit(SignupNavToEmailVerificationState());
  }

  FutureOr<void> signupToLoginClickedEvent(
      SignupToLoginClickedEvent event, Emitter<SignupState> emit) {
    emit(SignupNavToLoginState());
  }
}
