//
// import 'package:absensi/models/auth/login_body.dart';
// import 'package:absensi/services/auth/auth_service.dart';
// import 'package:bloc/bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:meta/meta.dart';
//
// part 'auth_state.dart';
//
// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit() : super(AuthInitial());
//
//   final box = GetStorage();
//
//   void login(LoginBody body) async {
//     emit(AuthLoading());
//
//     final data = await AuthService.login(body);
//
//
//     if (data.status == 200) {
//       box.write('kdUser', data.body!.kdUser);
//       box.write('nik', data.body!.nik);
//       emit(AuthSuccess());
//     } else {
//       Fluttertoast.showToast(msg: "message");
//     }
//   }
//
// }
