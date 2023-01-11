import 'package:absensi/models/status_absen/status_absen_body.dart';
import 'package:absensi/models/status_absen/status_absen_model.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/gen_token/gen_token_body.dart';
import '../auth/gen_token_service.dart';

class StatusAbsenService {
  static Future<StatusAbsenModel> absen(StatusAbsenBody body) async {
    String url = "absensi.gorutkab.go.id:8888";
    // String url = "10.100.1.96:8080";
    final box = GetStorage();
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ' + dataToken.body!.token;
    try {
      Response response = await dio
          .post('http://$url/absensi/status', data: body.toJson());
      return StatusAbsenModel.fromJson(response.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
