import 'dart:convert';
import 'dart:io';
import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/models/status_absen/status_absen_body.dart';
import 'package:absensi/offline/absen_harian_offline.dart';
import 'package:absensi/offline/configpage.dart';
import 'package:absensi/pages/absen-sakit.dart';
import 'package:absensi/pages/navigasi.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

const String kFileName = 'rekapan.json';

class AbsenPageOffline extends StatefulWidget {
  const AbsenPageOffline({Key? key}) : super(key: key);

  @override
  State<AbsenPageOffline> createState() => _AbsenPageOfflineState();
}

class _AbsenPageOfflineState extends State<AbsenPageOffline> {
  AnimationController? controller;
  File? _filePath;
  String? _versionapp;
  String? status;
  String? day;
  String? nik;
  String? Kduser;
  String? UnitKerja;
  String? Nama;
  String? month;
  String? year;
  String? hour;
  String? minute;
  bool _filexists = false;
  bool? filexists;
   List<String> splitted = [''];
  List<String> split_= [''];

  String? id_jenis;

  Future checkstatusconfig() async {
    String _status = "";
    final path = await _localPath;
    try {
      final file = File('$path/config.json');
      final String response = await file.readAsString();
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String decoded = stringToBase64.decode(response);
      String decoded2 = stringToBase64.decode(decoded);
      final data = await json.decode(decoded2);
      _status = data["status"];

      setState(() {
        status = _status;
      });
    } catch (e) {
      status = "online";
    }
  }

  Future _refresh() async {
    _filePath = await _localFile;
    // 0. Check whether the _file exists
    _filexists = await _filePath!.exists();
    await Future.delayed(Duration(seconds: 2));
    await CheckUserConeection();
    await checkstatusconfig();
    setState(() {
      if (ActiveConnection == true && status == "online") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Navigasi()));
      } else {
        if (_filexists == false && ActiveConnection == false) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ConfigPage()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        }
      }

      // if(ActiveConnection == true){
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (BuildContext context) => Navigasi()));
      // }
      // else{
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (BuildContext context) => super.widget));
      // }
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.json');
  }

  Future<File> get localfilerekap async {
    final path = await _localPath;
    return File('$path/$kFileName');
  }

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

  Future<void> readJson() async {
    final path = await _localPath;

    final storage = GetStorage();
    final file = File('$path/config.json');
    final String response = await file.readAsString();

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded = stringToBase64.decode(response);
    String decoded2 = stringToBase64.decode(decoded);
    final data = await json.decode(decoded2);

    setState(() {
      nik = data["nik"];
      Kduser = data["kdUser"];
      Nama = data["nama"];
      UnitKerja = data["unitKerja"];
      bool isLogin = storage.hasData('kdUser');
      if (!isLogin) {
        storage.write("nik", nik);
        storage.write("kdUser", Kduser);
      }
    });
  }

  final box = GetStorage();
  bool? buttonspt = true;
  bool? spt = false;
  String? textabsen = "mohon tunggu";
  bool ActiveConnection = false;
  String _hariaktif = "0";
  String _hariefektif = "0";
  String? _presensi = '0.0';
  String? _deviceId;
  String? _waktuu;
  bool? buttondisabled = false;
  bool? buttondisabledharian = false;

  bool? buttondisabledluar = false;
  bool? buttonsakitdisabled = false;

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

    });
    // if (data.body!.statusAbsen == false){
    //  _isButtonDisabled =  false;
    // }else{
    //   _isButtonDisabled = true;
    // }
  }

  void toashabsen() async {
    setState(() {});
  }

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    availableCameras();
  }

  void initState() {
    super.initState();
    _asyncMethod();
    CheckUserConeection();
    _getId();
    getLocation();
    kondisispt();
    time();
    package();
    readJson();
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

                              var _file = await localfilerekap;
                              filexists = await _file.exists();

                              if (!filexists!) {
                                _file.create();
                              } else {
                                final String response = await _file.readAsString();
                                if (!response.isEmpty) {
                                  var objeklist =
                                      json.decode(response)['data'] as List;
                                  _waktuu =
                                      objeklist[objeklist.length - 1]['waktu'];
                                   id_jenis =    objeklist[objeklist.length - 1]['idjenis'];
                                   splitted = _waktuu!.split(' ');
                                  final _date = DateTime.now();
                                  String _waktu = _date.toString();
                                 split_ = _waktu.split(' ');

                                }
                                if (filexists!  && split_[0] == splitted[0] && id_jenis == '2') {
                                  Fluttertoast.showToast(
                                      msg:
                                      "Anda Telah Selesai Melakukan Presensi Hari ini")
                                      .toString();
                                } else {
                                  Navigator.of(context, rootNavigator: false)
                                      .push(MaterialPageRoute(
                                      builder: (context) => AbsenPageOff(
                                          camera: firstCamera),
                                      maintainState: false));
                                }


                              }
                              setState(() {

                              });
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
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: Text('Version : $_versionapp'),
                        ),

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
