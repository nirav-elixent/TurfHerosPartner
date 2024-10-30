import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:turf_heros_owner/flavor_config.dart';
import 'package:turf_heros_owner/screens/Splash_screen/view.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  
  FlavorConfig(
    flavor: Flavor.dev,
    name: "Development",
    apiUrl: "https://turfheros.testbeta.app",
  );
  
  // FlavorConfig(
  //   flavor: Flavor.prod,
  //   name: "Producation",
  //   apiUrl: "https://turfheros.com",
  // );

  HttpOverrides.global = MyHttpOverrides();

  runApp(ScreenUtilInit(
    designSize: Size(375, 812),
    splitScreenMode: true,
    builder: (context, child) => MyApp(),
  ));
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
