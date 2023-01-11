import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

const String kFileName = 'myJsonFile2.json';

class AbsenPageOff extends StatefulWidget {
  const AbsenPageOff({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<AbsenPageOff> createState() => _AbsenPageOffState();
}

class _AbsenPageOffState extends State<AbsenPageOff> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _fileExists = false;
  File? _filePath;
  List _jsonlist = [];
  Map<String, dynamic> _json = {};
  String? _jsonString;
  Barcode? _result;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$kFileName');
  }

  void _writeJson(
      String nik,
      dynamic value1,
      String idJenisabsen,
      dynamic value2,
      String waktu,
      dynamic value3,
      String kdAbsensi,
      dynamic value4,
      String urlImage,
      dynamic value5,
      String latitude,
      dynamic value6,
      String longitude,
      dynamic value7,
      String kdlokasi,
      dynamic value8) async {
    // Initialize the local _filePath
    //final _filePath = await _localFile;

    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> _newJson = {
      nik: value1,
      idJenisabsen: value2,
      waktu: value3,
      kdAbsensi: value4,
      urlImage: value5,
      latitude: value6,
      longitude: value7,
      kdlokasi: value8,
    };
    print('1.(_writeJson) _newJson: $_newJson');

    //2. Update _json by adding _newJson<Map> -> _json<Map>
    // _json.addAll(_newJson);
    // print('2.(_writeJson) _json(updated): $_json');

    _jsonlist.add(_newJson);

    //3. Convert _json ->_jsonString
    _jsonString = jsonEncode(_jsonlist);
    print('3.(_writeJson) _jsonString: $_jsonString\n - \n');

    //4. Write _jsonString to the _filePath
    _filePath!.writeAsString(_jsonString!);
  }

  void _readJson() async {
    // Initialize _filePath
    _filePath = await _localFile;

    // 0. Check whether the _file exists
    _fileExists = await _filePath!.exists();
    print('0. File exists? $_fileExists');

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await _filePath!.readAsString();
        print('1.(_readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        _jsonlist = jsonDecode(_jsonString!);
        print('2.(_readJson) _json: $_json \n - \n');
      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
  }

  void deleteFile() async {
    _filePath = await _localFile;
    _fileExists = await _filePath!.exists();
    if (_fileExists) {
      // _filePath!.delete(recursive: true);
    }
  }



  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Fluttertoast.showToast(msg: scanData.code.toString());
      take();
      setState(() {
        _result = scanData;
      });
    });
  }

  void take() async {
    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    var uuid = Uuid();
    final now = DateTime.now();
    String waktu = now.toString();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    String lat = position.latitude.toString();
    String lot = position.longitude.toString();

    final image = await _controller!.takePicture();


    File compressedFile = await FlutterNativeImage.compressImage(image.path,
        quality: 80, percentage: 100);
    Uint8List? bytes = await (compressedFile.readAsBytesSync());

    var _base64 = base64Encode(bytes!);

    _writeJson(
        'nik',
        '0000001',
        'idjenis',
        '1',
        'waktu',
        waktu,
        'kdAbensi',
        uuid.v4(),
        'urlimage',
        _base64,
        'latitude',
        lat,
        'longitude',
        lot,
        'kdLokasi',
        '${_result!.code}');
    final file = await _localFile;
    _fileExists = await file.exists();
    //_fileName = file;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _readJson();
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
    _controller?.dispose();
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
                )),
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
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
