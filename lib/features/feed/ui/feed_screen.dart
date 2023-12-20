import 'package:farmeasy/features/feed/bloc/feed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    feedBloc.add(FeedInitialEvent());
    super.initState();
  }

  FeedBloc feedBloc = FeedBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: feedBloc,
      listenWhen: (previous, current) => current is FeedActionState,
      buildWhen: (previous, current) => current is! FeedActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case FeedInitial:
            return const Center(
              child: Text("Feed Screen"),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
