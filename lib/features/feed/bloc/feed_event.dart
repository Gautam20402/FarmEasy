part of 'feed_bloc.dart';

@immutable
abstract class FeedEvent {}

class FeedInitialEvent extends FeedEvent {}

class FeedLoadCompleteEvent extends FeedEvent {}
