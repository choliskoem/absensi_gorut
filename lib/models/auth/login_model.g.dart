// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
  status: json['status'] as int,
  body: json['body'] == null
      ? null
      : DataLoginModel.fromJson(json['body'] as Map<String, dynamic>),
);

DataLoginModel _$DataLoginModelFromJson(Map<String, dynamic> json) =>
    DataLoginModel(
      kdUser: json['kdUser'] as String,
      nik: json['nik'] as String,


    );
