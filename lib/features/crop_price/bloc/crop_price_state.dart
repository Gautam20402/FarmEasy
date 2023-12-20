part of 'crop_price_bloc.dart';

@immutable
abstract class CropPriceState {}

abstract class CropPriceActionState extends CropPriceState {}

class CropPriceInitial extends CropPriceState {}
