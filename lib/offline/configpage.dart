import 'dart:io';

import 'package:absensi/offline/widget/configcontainer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  FilePickerResult? result;
  String? _versionapp;
  List<PlatformFile> files = [];
  bool visible = false;

  File? _filePath;
  String _fileExists = "";

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


  Widget _submitButton() {
    return Visibility(
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () async {
            result = await FilePicker.platform.pickFiles(allowMultiple: false);
            if (result == null) {
              print("No file selected");
            } else {
              setState(() {});
              result?.files.forEach((element) {
                print(element.name);
              });

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

  Widget _configButton() {
    return Visibility(
      visible: visible,
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () async {

          },
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Konfigurasi',
              style: TextStyle(
                  color: Color.fromRGBO(76, 81, 93, 1),
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
            ),
            SizedBox.fromSize(
              size: Size.square(70.0), // button width and height
              child: ClipOval(
                child: Material(
                  color: Color.fromRGBO(76, 81, 93, 1),
                  child:
                  Icon(Icons.settings, color: Colors.white), // button color
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    package();

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.50,
                child: SigninContainer()),
            SingleChildScrollView(
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

                        SizedBox(height: 20),
                        Text("File :"),


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
