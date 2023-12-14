import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../const.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    List<String> drawerTitles = ['1', '2', '3', '4'];
    List<IconData> drawerIcons = [
      Icons.book,
      Icons.rocket_launch,
      Icons.handshake_outlined,
      Icons.fire_truck_outlined
    ];
    List<String> routes = ['/guide', '/competition', '/donate', '/vendor'];
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      drawerScrimColor: Colors.black87,
      endDrawer: Drawer(
        backgroundColor: CustomColors.primaryColor,
        child: Center(
          child: ListView.builder(
              itemCount: drawerTitles.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  left: width * 0.09,
                  right: width * 0.04,
                  bottom: width * 0.75),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    drawerIcons[index],
                    color: Colors.white,
                  ),
                  title: Text(
                    drawerTitles[index],
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.pushNamed(context, routes[index]),
                );
              }),
        ),
      ),
      appBar: AppBar(
        title: const Text("Weather"),
      ),
    );
  }
}
