import 'package:absensi/offline/configpage.dart';
import 'package:absensi/pages/halaman_login.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(SplashScreenoff());

class SplashScreenoff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
            duration: 3000,
            splash: Image(
              image: AssetImage('assets/images/group.png'),

            ),
            splashIconSize: 150,
            nextScreen: ConfigPage(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.topToBottom,
            backgroundColor: Colors.white));

  }
}
