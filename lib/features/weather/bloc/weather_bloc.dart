import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherLoadingEvent>(weatherLoadingEvent);
    on<WeatherReadyEvent>(weatherReadyEvent);
  }

  FutureOr<void> weatherLoadingEvent(
      WeatherLoadingEvent event, Emitter<WeatherState> emit) {
    emit(WeatherLoadingState());
  }

  FutureOr<void> weatherReadyEvent(
      WeatherReadyEvent event, Emitter<WeatherState> emit) {
    emit(WeatherReadyState());
  }
}
