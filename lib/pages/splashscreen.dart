import 'package:absensi/pages/halaman_login.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
            duration: 3000,
            splash: Image(
              image: AssetImage('assets/images/group.png'),

            ),
            splashIconSize: 150,
            nextScreen: HalamanLogin(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.topToBottom,
            backgroundColor: Colors.white));

  }
}
