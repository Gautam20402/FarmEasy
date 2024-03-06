import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<EmailVerificationInitialEvent>(emailVerificationInitialEvent);
    on<EmailVerificationDoneEvent>(emailVerificationDoneEvent);
    on<EmailVerificationCancelButtonClickedEvent>(
        emailVerificationCancelButtonClickedEvent);
    on<WaitingForVerificationEvent>(waitingForVerificationEvent);
  }

  FutureOr<void> emailVerificationInitialEvent(
      EmailVerificationInitialEvent event,
      Emitter<EmailVerificationState> emit) {
    emit(EmailVerificationInitial());
  }

  FutureOr<void> emailVerificationDoneEvent(
      EmailVerificationDoneEvent event, Emitter<EmailVerificationState> emit) {
    emit(EmailVerificationDoneActionState());
  }

  FutureOr<void> emailVerificationCancelButtonClickedEvent(
      EmailVerificationCancelButtonClickedEvent event,
      Emitter<EmailVerificationState> emit) {
    emit(EmailVerificationNavToLandingScreenActionState());
  }

  FutureOr<void> waitingForVerificationEvent(
      WaitingForVerificationEvent event, Emitter<EmailVerificationState> emit) {
    emit(WaitingForVerificationState());
  }
}
