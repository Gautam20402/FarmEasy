import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<FeedInitialEvent>(feedInitialEvent);
    on<FeedLoadCompleteEvent>(feedLoadCompleteEvent);
  }

  FutureOr<void> feedInitialEvent(
      FeedInitialEvent event, Emitter<FeedState> emit) {
    emit(FeedInitial());
  }

  FutureOr<void> feedLoadCompleteEvent(
      FeedLoadCompleteEvent event, Emitter<FeedState> emit) {
    emit(FeedLoadCompleteState());
  }
}
