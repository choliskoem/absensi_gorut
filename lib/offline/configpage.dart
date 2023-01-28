import 'dart:convert';
import 'dart:io';

import 'package:absensi/main.dart';
import 'package:absensi/offline/absen_page_offline.dart';
import 'package:absensi/offline/widget/configcontainer.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/pages/splashscreennav.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:path_provider/path_provider.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  FilePickerResult? result;
  String? _versionapp;
  List<PlatformFile> files = [];
  bool visible = true;

  File? _filePath;

  bool _filexists = false;

  String? status = "" ;
  bool ActiveConnection = false;
  Future checkstatusconfig() async {
    String _status = "";
    final path = await _localPath;
    try{
      final file = File('$path/config.json');
      final String response = await file.readAsString();
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String decoded = stringToBase64.decode(response);
      String decoded2 = stringToBase64.decode(decoded);
      final data = await json.decode(decoded2);
      _status = data["status"] ;



      setState(() {
        status = _status;

      });
    }catch (e){
      status ="online";
    }



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
  Widget _submitButton() {
    return Visibility(
      visible: !visible,
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () async {
            final result =
                await FilePicker.platform.pickFiles(allowMultiple: false);

            if (result == null) return;

            final file = result.files.first;

            final newfile = await savepermanently(file);

            print('from path : ${file.path}');
            print('to path  : ${newfile!.path}');

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => ConfigPage()));
          },
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox.fromSize(
              size: Size.square(70.0), // button width and height
              child: ClipOval(
                child: Material(
                  color: Color.fromRGBO(76, 81, 93, 1),
                  child:
                      Icon(Icons.upload, color: Colors.white), // button color
                ),
              ),
            ),
            Text(
              'Unggah',
              style: TextStyle(
                  color: Color.fromRGBO(76, 81, 93, 1),
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
            ),
          ]),
        ),
      ),
    );
  }
  Widget _nextButton() {
    return Visibility(
      visible: visible,
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () async {
            await CheckUserConeection();
            await checkstatusconfig();
            if(ActiveConnection == true && status == "online") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => Navigasi()));
            }else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AbsenPageOffline()));
              }

          },
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox.fromSize(
              size: Size.square(70.0), // button width and height
              child: ClipOval(
                child: Material(
                  color: Color.fromRGBO(76, 81, 93, 1),
                  child:
                  Icon(Icons.arrow_right_alt_rounded, color: Colors.white), // button color
                ),
              ),
            ),
            Text(
              'Konfigurasi Selesai',
              style: TextStyle(
                  color: Color.fromRGBO(76, 81, 93, 1),
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
            ),
          ]),
        ),
      ),
    );
  }

  Future<File?> savepermanently(PlatformFile file) async {
    final appstorage = await getApplicationDocumentsDirectory();
    final newfile = File('${appstorage.path}/${file.name}');

    return File(file.path!).copy(newfile.path);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.json');
  }

  void read() async {
    _filePath = await _localFile;

    // 0. Check whether the _file exists
    _filexists = await _filePath!.exists();

    visible = _filexists;
    print('0. File exists? $_filexists');
  }

  @override
  void initState() {
    super.initState();

    package();
    read();
    CheckUserConeection();
    checkstatusconfig();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
                height: MediaQuery.of(context).size.height * 0.50,
                child: SigninContainer()),
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: height * .55),
                          Text(
                            "UNGGAH FILE KONFIGURASI ",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          Text(
                            "File konfiguras dapat diperoleh dari operator masing-masing ",
                            style: TextStyle(fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 50),
                          _submitButton(),
                          _nextButton(),

                          SizedBox(height: 20),



                          // ListView.builder(itemBuilder: (context, index){
                          //        return Text(result?.files[index].name ?? "");
                          // }),
                          SizedBox(
                            height: 100,
                          ),
                          Row(
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
                          SizedBox(height: height * .050),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }
}
