import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<LoginForgotClickedEvent>(loginForgotClickedEvent);
    on<LoginToSignupClickedEvent>(loginToSignupClickedEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<LoginState> emit) {
    emit(LoginNavToEmailVerificationState());
  }

  FutureOr<void> loginForgotClickedEvent(
      LoginForgotClickedEvent event, Emitter<LoginState> emit) {
    emit(LoginNavToForgotPassState());
  }

  FutureOr<void> loginToSignupClickedEvent(
      LoginToSignupClickedEvent event, Emitter<LoginState> emit) {
    emit(LoginNavToSignupState());
  }
}
