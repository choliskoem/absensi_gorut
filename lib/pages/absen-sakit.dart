import 'dart:typed_data';

import 'package:absensi/pages/home_page.dart';
import 'package:absensi/pages/navigasi.dart';
import 'package:absensi/services/multipart/multipart-service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/my_color.dart';

class AbsenSakit extends StatefulWidget {
  const AbsenSakit({Key? key, required this.camera}) : super(key: key);
  final List<CameraDescription> camera;

  @override
  State<AbsenSakit> createState() => _AbsenSakitState();
}

class _AbsenSakitState extends State<AbsenSakit> {
  bool _loading = true;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  void takePhoto() async {
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
      service.AbsenSakit(bytes).then((value) {
        Navigator.of(context, rootNavigator: false).pushReplacement(MaterialPageRoute(builder: (context) =>  Navigasi()));

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

//
// @override
// void frontcamera() async{
//   final cameras = await availableCameras(); //get list of available cameras
//   final frontCam = cameras[1];
//
//
// }

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

  @override
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
                  takePhoto();
                },
                child: const Icon(Icons.camera_alt),
              ))
          : Column(
              children: [
                SizedBox(
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: WillPopScope(
                    onWillPop: () async => false,
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
                ),
              ],
            ),
    );
  }
}
