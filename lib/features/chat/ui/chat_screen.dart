import 'package:farmeasy/features/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    chatBloc.add(ChatInitialEvent());
    super.initState();
  }

  ChatBloc chatBloc = ChatBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: chatBloc,
      listenWhen: (previous, current) => current is ChatActionState,
      buildWhen: (previous, current) => current is! ChatActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case ChatInitial:
            return const Center(
              child: Text("Chat Screen"),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
