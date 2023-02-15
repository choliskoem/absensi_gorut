import 'dart:convert';
import 'dart:io';
import 'package:absensi/common/my_color.dart';
import 'package:absensi/common/my_typhography.dart';
import 'package:absensi/helper/helper.dart';
import 'package:absensi/offline/absen_harian_offline.dart';
import 'package:absensi/offline/absen_tugasluar_offline.dart';
import 'package:absensi/offline/configpage.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/pages/tugasluar.dart';
import 'package:absensi/widgets/my_appbar2.dart';
import 'package:absensi/widgets/my_button.dart';
import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

const String kFileName = 'rekapan.json';

class AbsenPageOffline extends StatefulWidget {
  const AbsenPageOffline({Key? key}) : super(key: key);

  @override
  State<AbsenPageOffline> createState() => _AbsenPageOfflineState();
}

class _AbsenPageOfflineState extends State<AbsenPageOffline> {
  AnimationController? controller;
  final box = GetStorage();
  File? _filePath;
  bool ActiveConnection = false;
  bool _filexists = false;
  bool? filexists;
  bool? buttonspt = true;
  bool? buttondisabled = false;
  bool? buttondisabledharian = false;
  bool? buttondisabledluar = false;
  bool? buttonsakitdisabled = false;
  bool? spt = false;
  String _hariaktif = "0";
  String _hariefektif = "0";
  String? textabsen = "mohon tunggu";
  String? _presensi = '0.0';
  String? _deviceId;
  String? _waktuu;
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
  String? id_jenis;
  List<String> splitted = [''];
  List<String> split_ = [''];
  Future<Directory?>? _downloadsDirectory;



  Future<File?> savepermanently(File file) async {
    String? path_;



    String path;
    path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final newfile = File('${path}/rekapan_${nik}_${split_[0]}.json');

    return File(file.path!).copy(newfile.path);
  }



  Future Download() async {
    final _date = DateTime.now();
    String _waktu = _date.toString();
    split_ = _waktu.split(' ');

    String _path;
    _path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final newfile = File('${_path}/rekapan_${nik}_${split_[0]}.json');

    _filePath = await newfile;
    // 0. Check whether the _file exists
    _filexists = await _filePath!.exists();

    if (_filexists == true) {
      Fluttertoast.showToast(msg: 'data sudah terdownload');

    }else{
      final path = await _localPath;

      final file = File('$path/rekapan.json');




      await savepermanently(file);

      _path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final newfile = File('${_path}/rekapan_${nik}_${split_[0]}.json');
      final String _response = await newfile.readAsString();
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encode = stringToBase64.encode(_response);
      String encode2 = stringToBase64.encode(encode);
      newfile!.writeAsString(encode2);


      print(2);

    }
  }

  Future _refresh() async {
    await Helper().read().then((value) {
      setState(() {
        _filexists = value;
      });
    });
    await Future.delayed(Duration(seconds: 2));
    await Helper().CheckUserConeection().then((value) {
      setState(() {
        ActiveConnection = value!;
      });
    });
    await Helper().checkstatusconfig().then((value) {
      setState(() {
        status = value;
      });
    });
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
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
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

  Future _Helper() async {
    await Helper().CheckUserConeection().then((value) {
      setState(() {
        ActiveConnection = value!;
      });
    });
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

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    availableCameras();
  }

  void initState() {
    super.initState();
    _Helper();
    getLocation();
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
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
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 1,
                                          // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: IconButton( onPressed: () { Download(); }, icon: Icon(Icons.download, color: Colors.white,)))
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Presensi',
                                    style: TextStyle(fontWeight: FontWeight.w700)),
                                const Text('Download',
                                    style: TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
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
                          child: Column(
                            children: [
                              Visibility(
                                visible: true,
                                child: Container(child: Text("Absen Harian")),
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
                                final String response =
                                    await _file.readAsString();
                                if (!response.isEmpty) {
                                  var objeklist =
                                      json.decode(response)['data'] as List;
                                  _waktuu =
                                      objeklist[objeklist.length - 1]['waktu'];
                                  id_jenis = objeklist[objeklist.length - 1]
                                      ['idjenis'];
                                  splitted = _waktuu!.split(' ');
                                  final _date = DateTime.now();
                                  String _waktu = _date.toString();
                                  split_ = _waktu.split(' ');
                                }
                                if (filexists! &&
                                    split_[0] == splitted[0] &&
                                    id_jenis == '2') {
                                  Fluttertoast.showToast(
                                          msg:
                                              "Anda Telah Selesai Melakukan Presensi Hari ini")
                                      .toString();
                                } else {
                                  Navigator.of(context, rootNavigator: false)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              AbsenPageOff(camera: firstCamera),
                                          maintainState: false));
                                }
                              }
                              setState(() {});
                            },
                            color: Colors.orange,
                            centerText: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 52),
                              child: Text("absen"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: Column(
                            children: [
                              Visibility(
                                  visible: true,
                                  child: Container(
                                      child: Text("Absen Tugas Luar"))),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: MyButton(
                            onTap: () async {
                              final cameras = await availableCameras();

                              var _file = await localfilerekap;
                              filexists = await _file.exists();

                              if (!filexists!) {
                                _file.create();
                              } else {
                                final String response =
                                    await _file.readAsString();
                                if (!response.isEmpty) {
                                  var objeklist =
                                      json.decode(response)['data'] as List;
                                  _waktuu =
                                      objeklist[objeklist.length - 1]['waktu'];
                                  id_jenis = objeklist[objeklist.length - 1]
                                      ['idjenis'];
                                  splitted = _waktuu!.split(' ');
                                  final _date = DateTime.now();
                                  String _waktu = _date.toString();
                                  split_ = _waktu.split(' ');
                                }
                                if (filexists! &&
                                    split_[0] == splitted[0] &&
                                    id_jenis == '2') {
                                  Fluttertoast.showToast(
                                          msg:
                                              "Anda Telah Selesai Melakukan Presensi Hari ini")
                                      .toString();
                                } else {
                                  await availableCameras().then((value) =>
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AbsenTugasLuarOffline(
                                                      camera: cameras))));
                                }
                              }
                              setState(() {});
                            },
                            color: Colors.orange,
                            centerText: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 52),
                              child: Text("absen "),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),

                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "SI-ABON",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '  offline',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.blue)),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text("Version : $_versionapp")
                              ],
                            ),
                          ),
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
