import 'dart:convert';
import 'dart:io';

import 'package:absensi/main.dart';
import 'package:path_provider/path_provider.dart';

class Helper {
  File? _filePath;
  bool ActiveConnection = false ;
  bool _filexists = false;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.json');
  }

  Future<String> checkstatusconfig() async {
    String _status = "";
    final path = await _localPath;
    try {
      final file = File('$path/config.json');
      final String response = await file.readAsString();
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String decoded = stringToBase64.decode(response);
      String decoded2 = stringToBase64.decode(decoded);
      final data = await json.decode(decoded2);
      _status = data["status"];

      print('offline conifg');
      return _status;

    } catch (e) {
      print('online conifg');
      return "online";
    }
  }

  Future<bool> read() async {

    _filePath = await _localFile;
    // 0. Check whether the _file exists
    _filexists = await _filePath!.exists();
    print('0. File exists? $_filexists');
    return _filexists;
  }

  Future<bool?> CheckUserConeection() async {

    try {
      final result = await InternetAddress.lookup('absensi.gorutkab.go.id');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("online");
       return true ;


      }
    } on SocketException catch (_) {
      print("offline");
      return false;



    }


  }
}
