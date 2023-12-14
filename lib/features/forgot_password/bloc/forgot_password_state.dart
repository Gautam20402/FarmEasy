part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

abstract class ForgotPasswordActionState extends ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class EmailSentSuccessActionState extends ForgotPasswordActionState {}

class ExceptionalActionState extends ForgotPasswordActionState {}
