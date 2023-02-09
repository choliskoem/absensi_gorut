import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

const String kFileName = 'rekapan.json';

class AbsenTugasLuarOffline extends StatefulWidget {
  const AbsenTugasLuarOffline({Key? key, required this.camera})
      : super(key: key);
  final List<CameraDescription> camera;

  @override
  State<AbsenTugasLuarOffline> createState() => _AbsenTugasLuarOfflineState();
}

class _AbsenTugasLuarOfflineState extends State<AbsenTugasLuarOffline> {

  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool? fileExists;
  bool _fileExists = false;
  File? _filePath;
  List<String> splitted = [''];
  List<String> split_ = [''];
  String? waktu;
  String? idjenis;
  String? nik;
  String? Kduser;
  String? UnitKerja;
  String? Nama;
  List _jsonlist = [];
  Map<String, dynamic> _json = {};
  String? _jsonString;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$kFileName');
  }

  Future<void> kondisi() async {
    var _file = await _localFile;
    fileExists = await _file.exists();
    if (!fileExists!) {
      _file.create();
    } else {
      final String response = await _file.readAsString();
      if (!response.isEmpty) {
        var objeklist = json.decode(response)['data'] as List;
        waktu = objeklist[objeklist.length - 1]['waktu'];
        splitted = waktu!.split(' ');
        final _date = DateTime.now();
        String _waktu = _date.toString();
        split_ = _waktu.split(' ');
        if (splitted[0] == split_[0]) {
          idjenis = "2";
        }
      }
    }
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
      dynamic value8,
      String status,
      dynamic value9) async {
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
      status: value9
    };
    print('1.(_writeJson) _newJson: $_newJson');

    _jsonlist.add(_newJson);
    _json = {"data": _jsonlist};

    //3. Convert _json ->_jsonString
    _jsonString = jsonEncode(_json);
    print('3.(_writeJson) _jsonString: $_jsonString\n - \n');

    //4. Write _jsonString to the _filePath
    _filePath!.writeAsString(_jsonString!);
  }

  Future _readJson() async {
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
        _json = jsonDecode(_jsonString!);

        _jsonlist = _json["data"];
        print('2.(_readJson) _json: $_json \n - \n');
      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
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

  void takePhoto() async {
    await readJson();
    var uuid = Uuid();
    final now = DateTime.now();
    String waktu_ = now.toString();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    String lat = position.latitude.toString();
    String lot = position.longitude.toString();
    try {
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;

      final image = await _cameraController.takePicture();

      if (!mounted) return;

      File compressedFile = await FlutterNativeImage.compressImage(image.path,
          quality: 80, percentage: 100);
      Uint8List? bytes = await (compressedFile.readAsBytesSync());

      var _base64 = base64Encode(bytes!);
      var _file = await _localFile;

      fileExists = await _file.exists();

      idjenis = "1";

      await kondisi();

      _writeJson(
        'nik',
        '$nik',
        'idjenis',
        idjenis,
        'waktu',
        waktu_,
        'kdAbensi',
        uuid.v4(),
        'urlimage',
        _base64,
        'latitude',
        lat,
        'longitude',
        lot,
        'kdLokasi',
        null,
        'status',
        'offline',
      );
      final file = await _localFile;
      _fileExists = await file.exists();
      //_fileName = file;
      Navigator.pop(context);
      setState(() {
        _cameraController.pausePreview();
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void frontcamera() async {
    final cameras = await availableCameras(); //get list of available cameras
    final frontCam = cameras[1];
  }

  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.camera[1], ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();

    _readJson();
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
        floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150),
            child: FloatingActionButton(
              onPressed: () async {
                takePhoto();
              },
              child: const Icon(Icons.camera_alt),
            )));
  }
}
