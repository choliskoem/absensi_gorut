import 'package:json_annotation/json_annotation.dart';

part 'login_body.g.dart';

@JsonSerializable(createFactory: false)
class LoginBody {
  final String email;
  final String password;
  final String deviceId;
  LoginBody({
    required this.email,
    required this.password,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => _$LoginBodyToJson(this);
}
