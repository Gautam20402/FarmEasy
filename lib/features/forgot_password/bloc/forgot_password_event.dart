part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class ForgotPasswordInitialEvent extends ForgotPasswordEvent {}

class ResetSuccessEvent extends ForgotPasswordEvent{}

class ExceptionalEvent extends ForgotPasswordEvent{}