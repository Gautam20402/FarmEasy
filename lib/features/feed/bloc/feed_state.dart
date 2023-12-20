part of 'feed_bloc.dart';

@immutable
abstract class FeedState {}

abstract class FeedActionState extends FeedState {}

class FeedInitial extends FeedState {}
