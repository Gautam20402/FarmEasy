import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'crop_price_event.dart';
part 'crop_price_state.dart';

class CropPriceBloc extends Bloc<CropPriceEvent, CropPriceState> {
  CropPriceBloc() : super(CropPriceInitial()) {
    on<CropPriceInitialEvent>(cropPriceIntialEvent);
  }

  FutureOr<void> cropPriceIntialEvent(
      CropPriceInitialEvent event, Emitter<CropPriceState> emit) {
    emit(CropPriceInitial());
  }
}
