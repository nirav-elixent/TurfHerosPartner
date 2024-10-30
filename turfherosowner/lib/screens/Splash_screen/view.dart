import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turf_heros_owner/const/appConstns/AppConstns.dart';
import 'package:turf_heros_owner/screens/Login_screen/view.dart';
import 'package:turf_heros_owner/screens/dashBoard_screen/view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? prefs;
  String authToken = "";
  final appVariable = Get.put(AppConstns());
  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkLocationPermission();
    navigater();

    // someFunction();
  }

  void _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs!.getString("authToken") ?? "";
  }

  navigater() {
    Timer(const Duration(seconds: 3), () {
      if (authToken.isEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (on) => const LoginScreen()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (cc) => const DashBoardSreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/splash_screen1.png",
                ),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/ball_image.svg"),
          ],
        ),
      ),
    );
  }

  void someFunction() {
    // final flavor = FlavorConfig.instance.flavor;
    // final apiUrl = FlavorConfig.instance.apiUrl;
    // final name = FlavorConfig.instance.name;

    // print("Flavor: $flavor");
    // print("API URL: $apiUrl");
    // print("Name: $name");
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    appVariable.currentPosition = position;
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getCurrentLocation();
    }
    _getCurrentLocation();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _getCurrentLocation();
    } else {
      _requestLocationPermission();
    }
  }
}
// ScreenUtil().screenWidth < 600