import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmeasy/const.dart';
import 'package:farmeasy/features/market/bloc/market_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/market_model.dart';
import '../../feed/ui/web_view_container.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  Random random = new Random();

  @override
  void initState() {
    marketBloc.add(MarketInitialEvent());
    super.initState();
  }

  MarketBloc marketBloc = MarketBloc();
  final _auth = FirebaseAuth.instance;
  final _cropformKey = GlobalKey<FormState>();
  late bool isSell = false;
  final nameEditingController = TextEditingController();
  final contactEditingController = TextEditingController();
  final cropEditingController = TextEditingController();
  final variantEditingController = TextEditingController();
  final cityEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int randomNum = random.nextInt(50);

    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = RegExp(r'^.{4,}$');
        if (value!.isEmpty) {
          return ("Name is required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please enter valid name(Min. 4 Characters)");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "Name",
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon: Icon(CupertinoIcons.person_circle_fill,
            color: CustomColors.primaryColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final contactField = TextFormField(
      autofocus: false,
      controller: contactEditingController,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return ("Mobile Number is required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please enter valid number(10 Characters)");
        }
        return null;
      },
      onSaved: (value) {
        contactEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "Contact",
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon: Icon(CupertinoIcons.phone_circle_fill,
            color: CustomColors.primaryColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Mobile No.",
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final cropField = TextFormField(
      autofocus: false,
      controller: cropEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("This Field is required");
        }
        return null;
      },
      onSaved: (value) {
        cropEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "Crop",
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon: Icon(Icons.grass_rounded, color: CustomColors.primaryColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Crop",
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final variantField = TextFormField(
      autofocus: false,
      controller: variantEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("This Field is required");
        }
        return null;
      },
      onSaved: (value) {
        variantEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "Variant",
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon: Icon(Icons.difference, color: CustomColors.primaryColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Variant",
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );
    final cityField = TextFormField(
      autofocus: false,
      controller: cityEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("This Field is required");
        }
        return null;
      },
      onSaved: (value) {
        cityEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: CustomColors.primaryColor,
      decoration: InputDecoration(
        labelText: "City",
        labelStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
        prefixIcon: Icon(Icons.place, color: CustomColors.primaryColor),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "City",
        hintStyle: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.primaryColor),
        ),
      ),
    );

    return BlocConsumer(
      bloc: marketBloc,
      listenWhen: (previous, current) => current is MarketActionState,
      buildWhen: (previous, current) => current is! MarketActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case MarketInitial:
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                foregroundColor: Colors.white,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: _cropformKey,
                                  child: ListView(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              postDetailsToFirestore();
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  CustomColors.secondaryColor,
                                            ),
                                            child: Text(
                                              "Post",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 24),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    "Do you want to Sell Crops"),
                                              ),
                                              Switch(
                                                onChanged: (value) {
                                                  setState(() {
                                                    isSell = value;
                                                  });
                                                },
                                                value: isSell,
                                                activeColor:
                                                    CustomColors.primaryColor,
                                                activeTrackColor:
                                                    Colors.greenAccent,
                                                inactiveThumbColor:
                                                    Colors.red[100],
                                                inactiveTrackColor:
                                                    Colors.redAccent,
                                              )
                                            ],
                                          ),
                                          nameField,
                                          const SizedBox(height: 24),
                                          contactField,
                                          const SizedBox(height: 24),
                                          cropField,
                                          const SizedBox(height: 24),
                                          variantField,
                                          const SizedBox(height: 24),
                                          cityField,
                                          const SizedBox(height: 400),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                foregroundColor: Colors.lightGreenAccent,
                child: Icon(
                  Icons.add,
                ),
              ),
              body: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('market').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final Color shuffleColor = Colors.primaries[
                              (randomNum + index) % Colors.primaries.length];
                          final DocumentSnapshot data =
                              snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: CustomColors.secondaryColor,
                                  )),
                              height: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  shuffleColor.withOpacity(0.4),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person_2,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          child: Text(
                                            data['name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          color: data['isSell'] == true
                                              ? Colors.red.withOpacity(0.4)
                                              : Colors.green.withOpacity(0.4),
                                          height: 24,
                                          width: 40,
                                          child: Center(
                                            child: Text(
                                              data['isSell'] == true
                                                  ? "sell"
                                                  : "buy",
                                              style: TextStyle(
                                                  color: data['isSell'] == true
                                                      ? Colors.redAccent[100]
                                                      : Colors
                                                          .greenAccent[100]),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 72),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Crop",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "Crop Variant",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "City",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                " : ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                " : ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                " : ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['crop'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                data['variant'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                data['city'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 64),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton.outlined(
                                          color: Colors.white,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WebViewContainer(
                                                        url:
                                                            "https://api.whatsapp.com/send?phone=${data['contact']}"),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                              Icons.contact_phone_outlined),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.primaryColor,
                      ),
                    );
                  }
                },
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  void postDetailsToFirestore() async {
    _cropformKey.currentState!.validate();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    MarketModel marketModel = MarketModel();
    if (_cropformKey.currentState!.validate()) {
      marketModel.uid = user?.uid;
      marketModel.name = nameEditingController.text;
      marketModel.contact = contactEditingController.text;
      marketModel.crop = cropEditingController.text;
      marketModel.variant = variantEditingController.text;
      marketModel.city = cityEditingController.text;
      marketModel.isSell = isSell;

      await firebaseFirestore
          .collection("market")
          .doc(user?.uid)
          .set(marketModel.toMap());
      Fluttertoast.showToast(msg: "Successfully Posted :)");
    }
    // signupBloc.add(SignupButtonClickedEvent());
  }
}
