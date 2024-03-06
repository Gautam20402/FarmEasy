part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherActionState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherReadyState extends WeatherState {}
