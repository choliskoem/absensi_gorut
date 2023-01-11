import 'dart:typed_data';

import 'package:absensi/models/gen_token/gen_token_body.dart';
import 'package:absensi/services/auth/gen_token_service.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

class Service {
  String url = "absensi.gorutkab.go.id:8888";
  // String url = "10.100.1.96:8080";
  Future<List<dynamic>?> AbsenTemanService() async {
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var res = await dio
          .post("http://$url/absensi/nik-teman", data: {"nik": nik});
      if (res.statusCode == 200) {
        return res.data['body'];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool?> AbsenQr(String qrCode) async {
    Dio dio = Dio();
    final box = GetStorage();
    String kduser = box.read("kdUser");
    String nik = box.read("nik");
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);

    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var res = await dio.post("http://$url/auth/scan-qrcode",
          data: {"kdUser": kduser, "qrCode": qrCode, "nik" : nik});
      if (res.statusCode == 200) {
        return res.data["body"]["status"];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>?> Absen(Uint8List file, String kdlokasi) async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String lat = position.latitude.toString();
    String lot = position.longitude.toString();
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");

    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var formData = FormData.fromMap({
        "kdLokasiKerja" : kdlokasi ,
        "nik": nik,
        "imageFile": MultipartFile.fromBytes(file, filename: "file.jpg"),
        "latitude": lat,
        "longitude": lot
      });
      var res =
          await dio.post("http://$url/absensi", data: formData);
      if (res.statusCode == 200) {
        return res.data["body"];

        Fluttertoast.showToast(msg: "Berhasil Absen");
        // return res.data["body"]["token"];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }




  Future<void> Tugasluar(Uint8List file) async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String lat = position.latitude.toString();
    String lot = position.longitude.toString();
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");

    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var formData = FormData.fromMap({
        "nik": nik,
        "imageFile": MultipartFile.fromBytes(file, filename: "file.jpg"),
        "latitude": lat,
        "longitude": lot
      });
      var res = await dio.post("http://$url/absensi/tugas-luar",
          data: formData);
      if (res.statusCode == 200) {
        Fluttertoast.showToast(msg: "Berhasil Absen");
        // return res.data["body"]["token"];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> AbsenSakit(Uint8List file) async {
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");

    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var formData = FormData.fromMap({
        "nik": nik,
        "imageFile": MultipartFile.fromBytes(file, filename: "file.jpg"),

      });
      var res = await dio.post("http://$url/absensi/upload-sakit",
          data: formData);
      if (res.statusCode == 200) {
        Fluttertoast.showToast(msg: "Berhasil Upload");
        // return res.data["body"]["token"];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> AbsenTeman(Uint8List file, String nikTeman) async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String lat = position.latitude.toString();
    String lot = position.longitude.toString();
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");

    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var formData = FormData.fromMap({
        "nikTeman" : nikTeman,
        "nik": nik,
        "imageFile": MultipartFile.fromBytes(file, filename: "file.jpg"),
        "latitude": lat,
        "longitude": lot
      });
      var res = await dio.post("http://$url/absensi/teman",
          data: formData);
      if (res.statusCode == 200) {
        Fluttertoast.showToast(msg: "Berhasil Absen");
        // return res.data["body"]["token"];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
