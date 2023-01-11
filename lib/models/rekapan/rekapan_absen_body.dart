import 'package:json_annotation/json_annotation.dart';

part 'rekapan_absen_body.g.dart';

@JsonSerializable(createFactory: false)
class RekapanAbsenBody {
  final String nik;
  RekapanAbsenBody({
    required this.nik,
  });

  Map<String, dynamic> toJson() => _$RekapanAbsenBodyToJson(this);
}
