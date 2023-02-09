import 'dart:io';
import 'dart:typed_data';

import 'package:absensi/common/my_color.dart';
import 'package:absensi/pages/rekap_absen.dart';
import 'package:absensi/services/multipart/multipart-service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool loading = true;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Fluttertoast.showToast(msg: scanData.code.toString());
      takePhoto(scanData.code.toString());
      // _cameraController.setFlashMode(FlashMode.off);
      // setState(() {
      //   result = scanData;
      // });

      // Navigator.pop(context);
    });
  }

  void takePhoto(String kdlokasi) async {
    try {
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;

      final image = await _cameraController.takePicture();

      if (!mounted) return;
      Service service = Service();
      Uint8List bytes = await image.readAsBytes();
      service.Absen(bytes, kdlokasi).then((value) {
        if (value!["stsAbsen"]) {
          Navigator.of(context, rootNavigator: false).pushReplacement(
              MaterialPageRoute(builder: (context) => RekapAbsen()));
        } else {
          Fluttertoast.showToast(msg: value!["message"].toString());
          Navigator.of(context, rootNavigator: false).pushReplacement(
              MaterialPageRoute(builder: (context) => RekapAbsen()));
        }
      });

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void getlokasi() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String lat = position.latitude.toString();
    String lot = position.longitude.toString();

    print('$lat, $lot');
  }

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    getlokasi();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: loading
                  ? QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                          borderRadius: 10,
                          borderWidth: 5,
                          borderColor: Colors.white),
                    )
                  : WillPopScope(
                      onWillPop: () async => false,
                      child: Column(
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
                    ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: MyColor.orange1),
                onPressed: () async {
                  await controller?.resumeCamera();
                },
                child:
                    const Text('Aktif Camera', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
