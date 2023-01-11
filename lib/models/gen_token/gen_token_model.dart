import 'package:json_annotation/json_annotation.dart';

part 'gen_token_model.g.dart';

@JsonSerializable(createToJson: false)
class GenTokenModel {
  final int status;
  final DataGenTokenModel? body;
  GenTokenModel({
    required this.status,
    this.body,
  });

  factory GenTokenModel.fromJson(Map<String, dynamic> json) =>
      _$GenTokenModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class DataGenTokenModel {
  @JsonKey(name: 'token')
  final String token;

  DataGenTokenModel({
    required this.token,

  });

  factory DataGenTokenModel.fromJson(Map<String, dynamic> json) =>
      _$DataGenTokenModelFromJson(json);
}
