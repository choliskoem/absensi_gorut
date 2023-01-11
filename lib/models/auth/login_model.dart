import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable(createToJson: false)
class LoginModel {
  final int status;
  final DataLoginModel? body;
  LoginModel({
    required this.status,
    this.body,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class DataLoginModel {
  @JsonKey(name: 'kdUser')
  final String kdUser;
  @JsonKey(name: 'nik')
  final String nik;


  DataLoginModel({
    required this.kdUser,
    required this.nik,


  });

  factory DataLoginModel.fromJson(Map<String, dynamic> json) =>
      _$DataLoginModelFromJson(json);
}
