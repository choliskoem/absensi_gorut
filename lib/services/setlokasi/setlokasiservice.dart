import 'package:absensi/models/gen_token/gen_token_body.dart';
import 'package:absensi/services/auth/gen_token_service.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

class SetelLokasi{
  String url = "absensi.gorutkab.go.id:8888";
  // String url = "10.100.1.96:8080";
  Future<bool?> statuslokasi() async {
    Dio dio = Dio();
    final box = GetStorage();
    String nik = box.read("nik");
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var res = await dio
          .post("http://$url/absensi/status-set-lokasi" , data: {"nik": nik});
      if (res.statusCode == 200) {

        bool insert  = res.data["body"]["sts"];
       bool update =  res.data["body"]["updatable"];

         return insert || update;
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic?> setellokasi() async {
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
      var res = await dio
          .post("http://$url/absensi/set-lokasi" , data: {
          "nik": nik,
          "latitude" : lat,
          "longitude" : lot

          });
      if (res.statusCode == 200) {
        return res.data["body"];
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
