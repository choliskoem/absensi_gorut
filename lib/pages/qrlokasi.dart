import 'dart:io';

import 'package:absensi/common/my_color.dart';
import 'package:absensi/services/setlokasi/setlokasiservice.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrLokasi extends StatefulWidget {
  const QrLokasi({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<QrLokasi> createState() => _QrLokasiState();
}

class _QrLokasiState extends State<QrLokasi> {
  String? message;
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
      take();
      _cameraController.setFlashMode(FlashMode.off);
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void take() async {
    String? _message;
    try {
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;

      if (!mounted) return;
      SetelLokasi service = SetelLokasi();
      service.setellokasi().then((value) {
        _message = value["message"].toString();
        Fluttertoast.showToast(msg: "$_message");
        Navigator.pop(context);
      });

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
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
                  : Column(
                      children: [
                        SizedBox(
                          height: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
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
