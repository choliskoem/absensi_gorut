import 'package:absensi/models/gen_token/gen_token_body.dart';
import 'package:absensi/services/auth/gen_token_service.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class HakAkses {
  String url = "absensi.gorutkab.go.id:8888";
  // String url = "10.100.1.96:8080";
  Future<dynamic> hakaksesmobile() async {
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var res = await dio
          .post("http://$url/auth/hak-akses-mobile", data: {"nik": nik});
      if (res.statusCode == 200) {
        return res.data;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> hakaksesweb() async {
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var res = await dio
          .post("http://$url/auth/hak-akses-web", data: {"nik": nik});
      if (res.statusCode == 200) {
        return res.data;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool?> statusabsenteman() async {
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var res = await dio
          .post("http://$url/absensi/status-absen-teman", data: {"nik": nik});
      if (res.statusCode == 200) {
        bool status  = res.data["body"]["statusAbsenTeman"];


        return status;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }



}