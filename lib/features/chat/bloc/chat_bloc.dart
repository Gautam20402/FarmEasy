import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatInitialEvent>(chatInitialEvent);
  }

  FutureOr<void> chatInitialEvent(
      ChatInitialEvent event, Emitter<ChatState> emit) {
    emit(ChatInitial());
  }
}
