import 'package:json_annotation/json_annotation.dart';

part 'status_absen_body.g.dart';

@JsonSerializable(createFactory: false)
class StatusAbsenBody {
  final String nik;
  StatusAbsenBody({
    required this.nik,
  });

  Map<String, dynamic> toJson() => _$StatusAbsenBodyToJson(this);
}
