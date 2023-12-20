import 'package:farmeasy/features/market/bloc/market_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  void initState() {
    marketBloc.add(MarketInitialEvent());
    super.initState();
  }

  MarketBloc marketBloc = MarketBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: marketBloc,
      listenWhen: (previous, current) => current is MarketActionState,
      buildWhen: (previous, current) => current is! MarketActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case MarketInitial:
            return const Center(
              child: Text("Market Screen"),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
