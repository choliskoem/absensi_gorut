
import 'dart:io';

import 'package:absensi/pages/HttpOverrides.dart';
import 'package:absensi/pages/splashscreen.dart';
import 'package:absensi/pages/splashscreennav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    bool isLogin = box.hasData('kdUser');

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: isLogin ?  SplashScreenNav() :  SplashScreen(),
    );
  }
}
