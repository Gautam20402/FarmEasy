part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

abstract class ChatActionState extends ChatState {}

class ChatInitial extends ChatState {}
