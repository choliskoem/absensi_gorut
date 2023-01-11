import 'package:json_annotation/json_annotation.dart';

part 'rekapan_absen_model.g.dart';

@JsonSerializable(createToJson: false)
class RekapanAbsenModel {
  final int status;
  final DataRekapanAbsenModel? body;
  RekapanAbsenModel({
    required this.status,
    this.body,
  });

  factory RekapanAbsenModel.fromJson(Map<String, dynamic> json) =>
      _$RekapanAbsenModelFromJson(json);

}

@JsonSerializable(createToJson: false)
class DataRekapanAbsenModel{
  @JsonKey(name: 'tahun')
  final int tahun ;
  @JsonKey(name: 'rekapanAbsen')
  final List<Child> rekapanAbsen;
  @JsonKey(name: 'bulan')
  final int bulan;
  DataRekapanAbsenModel({
    required this.tahun,
    required this.rekapanAbsen,
    required this.bulan,
  });

  factory DataRekapanAbsenModel.fromJson(Map<String, dynamic> json) => _$DataRekapanAbsenModelFromJson(json);
}
@JsonSerializable(createToJson:  false)
class Child{
  int hari;
  final DataAbsenMasuk? absenMasuk;
  final DataAbsenKeluar?  absenKeluar;

 Child({
  required this.hari,
    required this.absenMasuk,
   required this.absenKeluar
});

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

}
@JsonSerializable(createToJson: false)
class DataAbsenMasuk{
  @JsonKey(name: 'jenisAbsensi')
  final String jenisAbsensi ;
  @JsonKey(name: 'jam')
  final String jam;
  @JsonKey(name: 'presensi')
  final String presensi ;
  @JsonKey(name: 'stsValid')
  final bool stsValid;
  @JsonKey(name: 'kdAbsensi')
  final String kdAbsensi;
  DataAbsenMasuk({
    required this.jenisAbsensi,
    required this.jam,
    required this.presensi,
    required this.stsValid,
    required this.kdAbsensi
  });
  factory DataAbsenMasuk.fromJson(Map<String, dynamic> json) => _$DataAbsenMasukFromJson(json);
}
@JsonSerializable(createToJson: false)
class DataAbsenKeluar{
  @JsonKey(name: 'jenisAbsensi')
  final String jenisAbsensi ;
  @JsonKey(name: 'jam')
  final DateTime jam;
  @JsonKey(name: 'presensi')
  final String presensi ;
  @JsonKey(name: 'stsValid')
  final bool stsValid;
  @JsonKey(name: 'kdAbsensi')
  final String kdAbsensi;
  DataAbsenKeluar({
    required this.jenisAbsensi,
    required this.jam,
    required this.presensi,
    required this.stsValid,
    required this.kdAbsensi
  });
  factory DataAbsenKeluar.fromJson(Map<String, dynamic> json) => _$DataAbsenKeluarFromJson(json);



}