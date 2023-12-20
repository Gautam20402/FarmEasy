part of 'email_verification_bloc.dart';

@immutable
abstract class EmailVerificationEvent {}

class EmailVerificationInitialEvent extends EmailVerificationEvent {}

class EmailVerificationDoneEvent extends EmailVerificationEvent {}

class EmailVerificationCancelButtonClickedEvent
    extends EmailVerificationEvent {}
