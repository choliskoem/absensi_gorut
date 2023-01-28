import 'package:absensi/offline/absen_page_offline.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';



class SplashScreenNavOff extends StatefulWidget {
  @override
  State<SplashScreenNavOff> createState() => _SplashScreenNavOffState();
}

class _SplashScreenNavOffState extends State<SplashScreenNavOff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
            duration: 3000,
            splash: Image(
              image: AssetImage('assets/images/group.png'),
              height: 200,
            ),
            splashIconSize: 150,
            nextScreen: AbsenPageOffline(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.topToBottom,
            backgroundColor: Colors.white));
  }
}
