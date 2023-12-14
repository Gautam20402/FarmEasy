import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordInitialEvent>(forgotPasswordInitialEvent);
    on<ResetSuccessEvent>(resetSuccessEvent);
    on<ExceptionalEvent>(exceptionalEvent);
  }

  FutureOr<void> forgotPasswordInitialEvent(
      ForgotPasswordInitialEvent event, Emitter<ForgotPasswordState> emit) {
    emit(ForgotPasswordInitial());
  }

  FutureOr<void> resetSuccessEvent(
      ResetSuccessEvent event, Emitter<ForgotPasswordState> emit) {
    emit(EmailSentSuccessActionState());
  }

  FutureOr<void> exceptionalEvent(
      ExceptionalEvent event, Emitter<ForgotPasswordState> emit) {
    emit(ExceptionalActionState());
  }
}
