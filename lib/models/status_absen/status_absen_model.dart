import 'package:json_annotation/json_annotation.dart';

part 'status_absen_model.g.dart';

@JsonSerializable(createToJson: false)
class StatusAbsenModel {
  final int status;
  final DataStatusAbsenModel? body;
  StatusAbsenModel({
    required this.status,
    this.body,
  });

  factory StatusAbsenModel.fromJson(Map<String, dynamic> json) =>
      _$StatusAbsenModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class DataStatusAbsenModel {
  @JsonKey(name: 'hariEfektif')
  final int hariEfektif;
  @JsonKey(name: 'hariAktif')
  final int hariAktif;
  @JsonKey(name: 'presensi')
  final double presensi;
  @JsonKey(name: 'statusAbsen')
  final bool statusAbsen;
  @JsonKey(name: 'statusAbsenLuar')
  final bool statusAbsenLuar;
  @JsonKey(name: 'pesanAbsen')
  final String pesanAbsen;
  @JsonKey(name: 'statusAbsenSakit')
  final bool statusAbsenSakit;

  DataStatusAbsenModel({
    required this.hariAktif,
    required this.hariEfektif,
    required this.presensi,
    required this.statusAbsen,
    required this.statusAbsenLuar,
    required this.pesanAbsen,
    required this.statusAbsenSakit
  });

  factory DataStatusAbsenModel.fromJson(Map<String, dynamic> json) =>
      _$DataStatusAbsenModelFromJson(json);
}
