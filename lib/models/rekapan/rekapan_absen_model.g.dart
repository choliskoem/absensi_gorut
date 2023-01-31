// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rekapan_absen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RekapanAbsenModel _$RekapanAbsenModelFromJson(Map<String, dynamic> json) =>
    RekapanAbsenModel(
      status: json['status'] as int,
      body: json['body'] == null
          ? null
          : DataRekapanAbsenModel.fromJson(
          json['body'] as Map<String, dynamic>),
    );

DataRekapanAbsenModel _$DataRekapanAbsenModelFromJson(
    Map<String, dynamic> json) =>
    DataRekapanAbsenModel(
      tahun: json['tahun'] as int,
      rekapanAbsen: json['rekapanAbsen'] as List<Child>,
      bulan: json['bulan'] as int,

    );

DataAbsenMasuk _$DataAbsenMasukFromJson(Map<String, dynamic> json) =>
    DataAbsenMasuk(
        jenisAbsensi: json['jenisAbsensi'] as String,
        jam: json['jam'] as String,
        presensi: json['presensi'] as String,
        stsValid: json['stsValid'] as bool,
        kdAbsensi: json['kdAbsensi'] as String

    );

DataAbsenKeluar _$DataAbsenKeluarFromJson(Map<String, dynamic> json) =>
    DataAbsenKeluar(
        jenisAbsensi: json['jenisAbsensi'] as String,
        jam: json['jam'] as DateTime,
        presensi: json['presensi'] as String,
        stsValid: json['stsValid'] as bool,
        kdAbsensi: json['kdAbsensi'] as String

    );

DataIzinSakit _$DataIzinSakitFromJson(Map<String, dynamic> json) =>
    DataIzinSakit(
        jenisAbsensi: json['jenisAbsensi'] as String,
        jam: json['jam'] as DateTime,
        presensi: json['presensi'] as String,
        stsValid: json['stsValid'] as bool,
        kdAbsensi: json['kdAbsensi'] as String

    );


Child _$ChildFromJson(Map<String, dynamic> json) {
  return Child(
      hari: json['hari'] as int,
      absenMasuk: json['absenMasuk'] == null
          ? null
          : DataAbsenMasuk.fromJson(json['absenMasuk'] as Map<String, dynamic>),
      absenKeluar: json['absenKeluar'] == null
          ? null
          : DataAbsenKeluar.fromJson(
          json['absenKeluar'] as Map<String, dynamic>),
      izinSakit: json['izinSakit'] == null
          ? null
          : DataIzinSakit.fromJson(json['izinSakit'] as Map<String, dynamic>)

  );
}