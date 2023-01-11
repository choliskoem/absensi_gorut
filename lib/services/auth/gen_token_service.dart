import 'package:absensi/models/gen_token/gen_token_body.dart';
import 'package:absensi/models/gen_token/gen_token_model.dart';
import 'package:dio/dio.dart';

class GenTokenService {
  static Future<GenTokenModel> GenToken(GenTokenBody body) async {
    String url = "absensi.gorutkab.go.id:8888";
    // String url = "10.100.1.96:8080";
    Dio dio = Dio();

    try {
      Response response =
          await dio.post('http://$url/auth/gen-token', data: body.toJson());
      return GenTokenModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error');
    }
  }
}
