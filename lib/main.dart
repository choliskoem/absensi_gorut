
import 'dart:io';

import 'package:absensi/helper/helper.dart';
import 'package:absensi/offline/absen_page_offline.dart';
import 'package:absensi/offline/configpage.dart';
import 'package:absensi/pages/HttpOverrides.dart';
import 'package:absensi/pages/login_page.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/pages/splashscreen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool activeConnection = false ;
  // File? _filePath;
  bool _filexists = false;
  String? status  ;
  // Future checkstatusconfig() async {
  //   String _status = "";
  //   final path = await _localPath;
  //   try{
  //     final file = File('$path/config.json');
  //     final String response = await file.readAsString();
  //     Codec<String, String> stringToBase64 = utf8.fuse(base64);
  //     String decoded = stringToBase64.decode(response);
  //     String decoded2 = stringToBase64.decode(decoded);
  //     final data = await json.decode(decoded2);
  //     _status = data["status"] ;
  //
  //
  //
  //     setState(() {
  //       status = _status;
  //
  //     });
  //   }catch (e){
  //     status ="online";
  //   }
  //
  //
  //
  // }
  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }
  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/config.json');
  // }
  // Future read() async {
  //   _filePath = await _localFile;
  //
  //   // 0. Check whether the _file exists
  //   _filexists = await _filePath!.exists();
  //
  //   print('0. File exists? $_filexists');
  //
  //
  // }
  //
  // Future CheckUserConeection() async {
  //   try {
  //     final result = await InternetAddress.lookup('absensi.gorutkab.go.id');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty ) {
  //       setState(() {
  //         ActiveConnection = true;
  //         // Fluttertoast.showToast(msg: "Online");
  //       });
  //     }
  //   } on SocketException catch (_) {
  //     setState(() {
  //       ActiveConnection = false;
  //
  //
  //       // Fluttertoast.showToast(msg: "Offline");
  //     });
  //   }
  //
  //
  // }
  //

  Future helper() async {
    Helper().CheckUserConeection().then((value) {
      setState(() {
        activeConnection = value!;
      });

    });
    Helper().read().then((value) {

      setState(() {
        _filexists = value;
      });

    });
    Helper().checkstatusconfig().then((value) {
    setState(() {
      status = value;
    });


    });

  }





  @override
  void initState() {

    super.initState();
   //  CheckUserConeection();
   //  read();
   // checkstatusconfig();

    helper();


  }

  @override
  Widget build(BuildContext context) {

    final box = GetStorage();
    bool isLogin = box.hasData('kdUser');
    bool isonline = status == "online";
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: activeConnection  && isonline
          ? isLogin
              ? SplashScreen(value: const Navigasi())
              : SplashScreen(value: const LoginPage())
          : _filexists
              ? SplashScreen(value: const AbsenPageOffline())
              : SplashScreen(value: const ConfigPage()),
    );
  }
}
