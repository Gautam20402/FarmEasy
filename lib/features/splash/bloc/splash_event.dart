part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

class SplashLogInEvent extends SplashEvent {}

class SplashLogOutEvent extends SplashEvent {}
