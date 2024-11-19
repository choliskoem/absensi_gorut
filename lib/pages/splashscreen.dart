import 'package:absensi/pages/login_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  late final StatefulWidget value;

  SplashScreen({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var newpage = const LoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
            duration: 3000,
            splash: const Image(
              image: AssetImage('assets/images/group.png'),
            ),
            splashIconSize: 150,
            nextScreen: widget.value,
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.topToBottom,
            backgroundColor: Colors.white));
  }
}
