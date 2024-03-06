part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class WeatherLoadingEvent extends WeatherEvent {}

class WeatherReadyEvent extends WeatherEvent {}
