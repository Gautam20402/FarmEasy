import 'package:farmeasy/features/crop_price/bloc/crop_price_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropPriceShowScreen extends StatefulWidget {
  const CropPriceShowScreen({super.key});

  @override
  State<CropPriceShowScreen> createState() => _CropPriceShowScreenState();
}

class _CropPriceShowScreenState extends State<CropPriceShowScreen> {
  @override
  void initState() {
    cropPriceBloc.add(CropPriceInitialEvent());
    super.initState();
  }

  CropPriceBloc cropPriceBloc = CropPriceBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: cropPriceBloc,
      listenWhen: (previous, current) => current is CropPriceActionState,
      buildWhen: (previous, current) => current is! CropPriceActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case CropPriceInitial:
            return const Center(
              child: Text("CropPrice Screen"),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
