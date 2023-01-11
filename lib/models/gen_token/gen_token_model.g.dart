// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gen_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenTokenModel _$GenTokenModelFromJson(Map<String, dynamic> json) => GenTokenModel(
  status: json['status'] as int,
  body: json['body'] == null
      ? null
      : DataGenTokenModel.fromJson(json['body'] as Map<String, dynamic>),
);

DataGenTokenModel _$DataGenTokenModelFromJson(Map<String, dynamic> json) =>
    DataGenTokenModel(
      token: json['token'] as String,

    );
