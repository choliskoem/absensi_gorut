import 'dart:convert';
import 'package:absensi/common/my_color.dart';
import 'package:absensi/widgets/my_appbar2.dart';
import 'package:camera/camera.dart';
import 'package:absensi/services/multipart/multipart-service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DropdownModel {
  DropdownModel(this.nik, this.namaLengkap);

  String nik;
  String namaLengkap;
}

class AbsenTeman extends StatefulWidget {
  const AbsenTeman({Key? key}) : super(key: key);

  @override
  State<AbsenTeman> createState() => _AbsenTemanState();
}

class _AbsenTemanState extends State<AbsenTeman> {
  DropdownModel selectedModel = new DropdownModel("Mohon tunggu", "");
  List<DropdownModel> models = [];

  Future<void> _tampildata() async {
    List<DropdownModel> listData = [];
    // Map<String, String> data1 = Map();
    // data1["nik"] = "NIK";
    // data1["namaLengkap"] = "Nama";
    // _dataProvince.add(data1);
    var service = Service();
    // Fluttertoast.showToast(msg: "msg");
    service.AbsenTemanService().then((value) {
      value!.forEach((element) {
        // Fluttertoast.showToast(msg: "msg");
        DropdownModel data =
            new DropdownModel(element["nik"], element["namaLengkap"]);
        listData.add(data);
      });
      setState(() {
        selectedModel = listData[0];
        models = listData;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tampildata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyAppBar2(),
              SizedBox(
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Container(
                  width: 300,
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
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        FluentIcons.people_checkmark_24_filled,
                        size: 100,
                        color: MyColor.orange1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "ABSEN TEMAN",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 120,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<DropdownModel>(
                            isExpanded: true,
                            hint: Text("Absen Teman"),
                            value: selectedModel,
                            icon: const Icon(Icons.arrow_drop_down_sharp),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: MyColor.orange1,
                            ),
                            onChanged: (DropdownModel? value) {
                              // This is called when the user selects an item.
                              setState(() async {
                                final cameras = await availableCameras();
                                var route = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new NextPage(
                                          value: value!.nik, camera: cameras),
                                );
                                Navigator.of(context).push(route);
                              });
                            },
                            items: models
                                .map<DropdownMenuItem<DropdownModel>>((value) {
                              return DropdownMenuItem(
                                child: Text(
                                  value.namaLengkap,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                value: value,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  final String value;

  final List<CameraDescription> camera;

  NextPage({Key? key, required this.value, required this.camera})
      : super(key: key);

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {
  bool _loading = true;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  void takePhoto(String value) async {
    setState(() {
      _loading = false;
    });
    try {
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;

      final image = await _cameraController.takePicture();

      if (!mounted) return;
      Service service = Service();
      Uint8List bytes = await image.readAsBytes();
      service.AbsenTeman(bytes, value).then((value) {
        Navigator.pop(context);
      });
      setState(() {
        _loading = false;
        _cameraController.pausePreview();
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.camera[0], ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: _loading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: FloatingActionButton(
                onPressed: () async {
                  takePhoto(widget.value);
                },
                child: const Icon(Icons.camera_alt),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Container(
                    width: 300,
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
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Mohon Tunggu\nSedang Diproses..",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          color: Colors.purple,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
