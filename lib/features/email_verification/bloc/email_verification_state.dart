part of 'email_verification_bloc.dart';

@immutable
abstract class EmailVerificationState {}

abstract class EmailVerificationActionState extends EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationDoneActionState extends EmailVerificationActionState {}

class EmailVerificationNavToLandingScreenActionState
    extends EmailVerificationActionState {}
