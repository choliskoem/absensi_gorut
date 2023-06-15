

import 'package:absensi/models/gen_token/gen_token_body.dart';
import 'package:absensi/services/auth/gen_token_service.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class TambahProfilService {
  String url = "absensi.gorutkab.go.id:8888";
Future<dynamic>ganti(String kd, String nik ) async {
  Dio dio = Dio();
  final box = GetStorage();


  GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
  final dataToken = await GenTokenService.GenToken(tokenBody);
  dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
  try {
    var res = await dio
        .post("http://$url/pegawai/jenis",
        data: {
          "kdJenisPegawai": kd ,
          "nik": nik
        });
    if (res.statusCode == 200) {
      return res.data;
    }
    return null;
  } catch (e) {
    throw Exception(e.toString());
  }
}
}