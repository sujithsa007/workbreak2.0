/// Author : Sujith S A
/// Created on : 27th Apr 2021

/// Application entry point

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:work_break/utilities/color_swatches.dart';
import 'package:work_break/views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: CustomColor.colorCustom,
          fontFamily: '',
        ),
        home: AnimatedSplashScreen(
          duration: 2000,
          nextScreen: HomeScreen(),
          backgroundColor: Colors.white60,
          curve: Curves.bounceIn,
          pageTransitionType: PageTransitionType.fade,
          splash: Text('W O R K   B R E A K',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Future')),
        ));
  }
}
