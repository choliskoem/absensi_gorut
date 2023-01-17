import 'dart:io';

import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/models/status_absen/status_absen_body.dart';
import 'package:absensi/offline/absen_harian_offline.dart';
import 'package:absensi/pages/absen-sakit.dart';
import 'package:absensi/pages/qrcode.dart';
import 'package:absensi/pages/tugasluar.dart';
import 'package:absensi/services/auth/biodata_service.dart';
import 'package:absensi/services/status_absen/status_absen_service.dart';
import 'package:absensi/spt/spt_page.dart';
import 'package:absensi/widgets/my_appbar2.dart';
import 'package:absensi/widgets/my_button.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AbsenPageOffline extends StatefulWidget {
  const AbsenPageOffline({Key? key}) : super(key: key);

  @override
  State<AbsenPageOffline> createState() => _AbsenPageOfflineState();
}

class _AbsenPageOfflineState extends State<AbsenPageOffline> {
  AnimationController? controller;

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });
  }
  String? _versionapp;

  void package() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String versionapp = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      _versionapp = versionapp;
    });
  }

  String? day;

  String? month;

  String? year;
  String? hour;

  String? minute;

  final box = GetStorage();
  bool? buttonspt = true;
  bool? spt = false;
  bool? _isButtonDisabled = false;
  bool? _isButtonDisabledLuar = false;
  bool? _isButtonSakitDisabled = false;
  String? textabsen = "mohon tunggu";
  bool ActiveConnection = false;
  String _hariaktif = "0";
  String _hariefektif = "0";
  String? _presensi = '0.0';

  String? _deviceId;

  bool? buttondisabled = false;
  bool? buttondisabledharian = false;

  bool? buttondisabledluar = false;
  bool? buttonsakitdisabled = false;
  String? UnitKerja;

  String? Nama;

  void tampil() {
    String unit;
    String nama;
    var bio = BiodataService();

    bio.unitkerja().then((value) {
      unit = value!['unitKerja'].toString();

      setState(() {
        UnitKerja = unit;
      });
    });

    bio.biodata().then((value) {
      nama = value!['namaLengkap'].toString();

      setState(() {
        Nama = nama;
      });
    });
  }

  Future CheckUserConeection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
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

  Future<void> _getId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        setState(() {
          _deviceId = build.version.release;

          var parts = _deviceId!.split('.');
          var prefix = parts[0].trim();
          var myInt = int.parse(prefix);
          assert(myInt is int);

          buttondisabled = !(myInt <= 6);

          buttondisabledharian = buttondisabled! && !spt!;
          buttondisabledluar = !spt!;
          buttonsakitdisabled = !spt!;
        });
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;

        setState(() {
          _deviceId = data.identifierForVendor!;
        });
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: "error");
    }
  }

  Future<void> kondisispt() async {
    if (spt == 0) {
      buttonsakitdisabled = true;
    } else {
      buttonsakitdisabled = false;
    }
  }

  void time() async {
    var dt = DateTime.now();
    String _day = dt.day.toString();
    String _month = dt.month.toString();
    String _year = dt.year.toString();
    String _hour = dt.hour.toString();
    String _minute = dt.minute.toString();
    setState(() {
      day = _day;
      month = _month;
      year = _year;
      hour = _hour;
      minute = _minute;
    });
  }

  _asyncMethod() async {
    // var service = StatusAbsenService();
    // service.statusabsen().then((value) {
    //   setState(() {
    //     _isButtonDisabled = value;
    //   });
    // });
    StatusAbsenBody body = StatusAbsenBody(nik: box.read("nik"));
    final data = await StatusAbsenService.absen(body);
    setState(() {
      _hariaktif = data.body!.hariAktif.toString();
      _hariefektif = data.body!.hariEfektif.toString();
      double persen = data.body!.presensi.roundToDouble();
      _presensi = persen.toString();
      textabsen = data.body!.pesanAbsen;
      _isButtonDisabled = data.body!.statusAbsen;
      _isButtonDisabledLuar = data.body!.statusAbsenLuar;
      _isButtonSakitDisabled = data.body!.statusAbsenSakit;
    });
    // if (data.body!.statusAbsen == false){
    //  _isButtonDisabled =  false;
    // }else{
    //   _isButtonDisabled = true;
    // }
  }

  void initState() {
    super.initState();
    _asyncMethod();
    CheckUserConeection();
    _getId();
    tampil();
    kondisispt();
    time();
    package();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              child: Column(
                children: [
                  const MyAppBar2(),
                  const SizedBox(height: 23),
                  Text(
                    'ABSEN HARI INI',
                    style: MyTyphography.headingLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      '$UnitKerja',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: RichText(
                      text: TextSpan(
                        text: box.read("nik"),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text: '- $Nama',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            // topLeft: Radius.circular(10),
                            // topRight: Radius.circular(10),
                            ),
                        boxShadow: [
                          BoxShadow(
                            color: MyColor.orange1,
                            blurRadius: 1,
                            // Shadow position
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        children: <Widget>[
                          const Text('Detail Absen Harian',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 22),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Hari Efektif',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text('$_hariefektif',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Hari Aktif',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                Text('$_hariaktif',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              color: MyColor.orange1,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1,
                                  // Shadow position
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 4),
                              child: Column(
                                children: [
                                  Text(
                                    '$_presensi%',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text('Presensi',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$year-$month-$day',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text('$hour:$minute',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: Row(
                            children: [
                              Visibility(
                                visible: buttondisabledharian!,
                                child: Center(child: Text("Absen Harian")),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: MyButton(
                            onTap: () async {
                              final cameras = await availableCameras();
                              final firstCamera = cameras.first;

                              Navigator.of(context, rootNavigator: false).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AbsenPageOff(camera: firstCamera),
                                      maintainState: false));
                            },
                            color: Colors.orange,
                            centerText: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 52),
                              child: Text("absen masuk"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: Row(
                            children: [
                              Visibility(
                                  visible: buttondisabledluar!,
                                  child: Text("Absen Tugas Luar")),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: MyButton(
                            onTap: () async {
                              final cameras = await availableCameras();
                              await availableCameras().then((value) =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              TugasLuar(camera: cameras))));
                            },
                            color: Colors.orange,
                            centerText: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 52),
                              child: Text("absen masuk"),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                        Container(
                          child: Text('Version : $_versionapp'),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 100),
                        //   child: Row(
                        //     children: [
                        //       Visibility(
                        //           visible: buttonsakitdisabled!,
                        //           child: Text("Absen Sakit")),
                        //     ],
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: buttonsakitdisabled!,
                        //   child: MyButton(
                        //     onTap: () async {
                        //       if (_isButtonSakitDisabled!) {
                        //         final cameras = await availableCameras();
                        //         await availableCameras().then((value) =>
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (_) =>
                        //                         AbsenSakit(camera: cameras))));
                        //       }
                        //     },
                        //     color: _isButtonSakitDisabled!
                        //         ? MyColor.orange1
                        //         : Colors.grey,
                        //     centerText: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 15, horizontal: 82),
                        //       child: Text("Sakit"),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
