import 'dart:io';

import 'package:absensi/offline/configpage.dart';
import 'package:absensi/offline/widget/splashscreenoff.dart';
import 'package:absensi/pages/HttpOverrides.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/pages/splashscreen.dart';
import 'package:absensi/pages/splashscreennav.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool ActiveConnection = false;
  bool cekconfig = false;
  File? _filePath;

  bool _filexists = false;

  Future CheckUserConeection() async {
    try {
      final result = await InternetAddress.lookup('absensi.gorutkab.go.id');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          // Fluttertoast.showToast(msg: "Online");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        // Fluttertoast.showToast(msg: "Offline");
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/track.json');
  }

  void read() async {
    _filePath = await _localFile;

    // 0. Check whether the _file exists
    _filexists = await _filePath!.exists();

    print('0. File exists? $_filexists');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckUserConeection();
    read();
  }

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
        home: ActiveConnection
            ? isLogin
                ? SplashScreenNav()
                : SplashScreen()
            : _filexists
                ? SplashScreenNav()
                : SplashScreenoff(),
    );
  }
}
