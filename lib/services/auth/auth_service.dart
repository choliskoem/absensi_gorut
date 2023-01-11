import 'package:absensi/models/gen_token/gen_token_body.dart';
import 'package:absensi/services/auth/gen_token_service.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  String url = "absensi.gorutkab.go.id:8888";
  // String url = "10.100.1.96:8080";
  Future<dynamic> authService(String email, String password, String deviceId) async {
    Dio dio = Dio();

    final box = GetStorage();
    // String nik = box.read("nik");

    try {
      //404
      var res = await dio.post("http://$url/auth/login",
          data: {"email": email, "password": password, "deviceId": deviceId});
      String nik = res.data['body']['nik'];
      String kdUser = res.data['body']['kdUser'];
      box.write("nik", nik);
      box.write("kdUser", kdUser);
      return res.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> ubahpassword( String passlama,String passbaru) async {

    Dio dio = Dio();
    final box = GetStorage();
    String kduser = box.read("kdUser");
    GenTokenBody tokenBody = GenTokenBody(kdUser: box.read("kdUser"));
    final dataToken = await GenTokenService.GenToken(tokenBody);
    dio.options.headers["Authorization"] = "Bearer ${dataToken.body!.token}";
    try {
      var res = await dio.post("http://$url/auth/ubah-password",
          data: {
            "kdUser": kduser,
            "passwordLama": passlama,
            "passwordBaru": passbaru
          });


      return res.data;
    } on DioError catch (e) {

      return e.response!.data;
    }
  }
}

// Fluttertoast.showToast(msg: "dasfafs");
//     var res = await dio.post("http://10.100.1.96:8080/auth/login", data: {"email": email, "password": password, "deviceId": deviceId});
//
//     if (res.statusCode == 200) {
//       String nik =  res.data['body']['nik'];
//       String kdUser =  res.data['body']['kdUser'];
//       box.write("nik", nik);
//       box.write("kdUser", kdUser);
//       return res.data['body'];
//
//     }
//     else if (res.statusCode == 401) {
//       String message = res.data['body']['message'];
//       Fluttertoast.showToast(msg:"ggal");
//     }
//   }
// }

//   static Future<LoginModel> login(LoginBody body) async {
//     Dio dio = Dio();
//
//
//     Response response = await dio.post('http://10.100.1.96:8080/auth/login',
//         data: body.toJson());
// if(response.statusCode == 200){
//   return LoginModel.fromJson(response.data);
// }
// else if (response.statusCode== 401){
//      Fluttertoast.showToast(msg: response.data["body"]["message"]).toString();
//     }
//

// try {
//
// } catch (e) {
// throw Exception(e);
// }
