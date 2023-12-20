part of 'market_bloc.dart';

@immutable
abstract class MarketState {}

abstract class MarketActionState extends MarketState {}

class MarketInitial extends MarketState {}
