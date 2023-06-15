// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_absen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusAbsenModel _$StatusAbsenModelFromJson(Map<String, dynamic> json) => StatusAbsenModel(
  status: json['status'] as int,
  body: json['body'] == null
      ? null
      : DataStatusAbsenModel.fromJson(json['body'] as Map<String, dynamic>),
);

DataStatusAbsenModel _$DataStatusAbsenModelFromJson(Map<String, dynamic> json) =>
    DataStatusAbsenModel(
      hariAktif: json['hariAktif'] as int,
      hariEfektif: json['hariEfektif'] as int,
      presensi:  json['presensi'] as double,
      presensiPermen:  json['presensiPermen'] as double,
      statusAbsen: json['statusAbsen'] as bool,
      statusAbsenLuar: json['statusAbsenLuar'] as bool,
      pesanAbsen: json['pesanAbsen'] as String,
      statusAbsenSakit: json['statusAbsenSakit'] as bool,

    );
