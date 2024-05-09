import 'package:farmeasy/features/crop_price/bloc/crop_price_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final List<String> crops = [
    "Animal Feed - Feed Ingredients",
    "Cotton",
    "Maize (Corn)",
    "Rice",
    "Wheat",
    "Guar Gum",
    "Guar Seed",
    "Rapeseed Meal",
    "Soymeal",
    "Groundnut (Peanut)",
    "Rapeseed (Mustard Seed)",
    "Soyabean",
    "Chana (Chickpeas)",
    "Masoor (Lentils)",
    "Moong (Mung Bean)",
    "Peas",
    "Tur (Pigeon Pea)",
    "Urad (Black Matpe)",
    "Black Pepper",
    "Cardamom",
    "Coriander",
    "Jeera (Cumin Seed)",
    "Red Chillies",
    "Turmeric",
    "Sugar/Jaggery (Gur)",
    "Palm Oil (Cpo)",
    "Rapeseed Oil",
    "Soy Oil",
  ];
  final List<String> cropLinks = [
    'animal-feed-658/products/animal-feed-feed-ingredients',
    'cotton/products/Cotton',
    'grains/products/Maize%20(Corn)',
    'grains/products/Rice',
    'grains/products/wheat',
    'guar/products/guar-gum',
    'guar/products/Guar%20Seed',
    'oilmeal/products/Rapeseed%20Meal',
    'oilmeal/products/soymeal-896',
    'oilseed/products/groundnut-peanut',
    'oilseed/products/rapeseed-mustard-seed',
    'oilseed/products/Soyabean',
    'pulses/products/chana-chickpeas',
    'pulses/products/masoor-lentils',
    'pulses/products/moong-mung-bean',
    'pulses/products/peas',
    'pulses/products/tur-pigeon-pea',
    'pulses/products/urad-black-matpe',
    'spices/products/black-pepper',
    'spices/products/cardamom',
    'spices/products/coriander',
    'spices/products/jeera-cumin-seed',
    'spices/products/red-chillies',
    'spices/products/turmeric',
    'sugargur/products/sugarjaggery-gur',
    'vegoils/products/palm-oil-cpo',
    'vegoils/products/rapeseed-oil',
    'vegoils/products/soy-oil',
  ];
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
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
              ),
              body: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: cropLinks.length,
                itemBuilder: (context, index) => ItemTile(
                  crops[index],
                  index,
                  cropLinks[index],
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class ItemTile extends StatelessWidget {
  final String item;
  final String path;
  final int itemNo;
  const ItemTile(this.item, this.itemNo, this.path);

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.primaries[itemNo % Colors.primaries.length];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: color.withOpacity(0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onTap: () async {
          final Uri url = Uri(
              scheme: 'https',
              host: 'www.agriwatch.com',
              path: '/commodities/$path');
          if (!await launchUrl(url,
              mode: LaunchMode.inAppWebView,
              webViewConfiguration:
                  WebViewConfiguration(enableJavaScript: true))) {
            throw Exception('Could not launch $url');
          }
        },
        title: Center(
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget MyButton() {
  return ElevatedButton(
    onPressed: () async {
      final Uri url = Uri(
          scheme: 'https',
          host: 'www.agriwatch.com',
          path: '/commodities/grains/products/wheat');
      if (!await launchUrl(url,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: WebViewConfiguration(enableJavaScript: true))) {
        throw Exception('Could not launch $url');
      }
    },
    child: Text("Launch URL"),
  );
}
