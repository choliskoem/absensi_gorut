import 'package:json_annotation/json_annotation.dart';

part 'gen_token_body.g.dart';

@JsonSerializable(createFactory: false)
class GenTokenBody {
  final String kdUser;
  GenTokenBody({
    required this.kdUser,
  });

  Map<String, dynamic> toJson() => _$GenTokenBodyToJson(this);
}
