import 'dart:io';

import 'package:absensi/common/my_color.dart';
import 'package:absensi/services/multipart/multipart-service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final GlobalKey qrKey = GlobalKey();
  Barcode? result;
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.resumeCamera();
      var service = Service();
      service.AbsenQr(scanData.code.toString()).then((value) => {
            if (value!)
              {Fluttertoast.showToast(msg: "berhasil login")}
            else
              {Fluttertoast.showToast(msg: "gagal login")}
          });

      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
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
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderWidth: 5,
                    borderColor: Colors.white),
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
