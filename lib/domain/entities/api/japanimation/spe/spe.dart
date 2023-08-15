import 'package:api/domain/entities/api/base_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spe.g.dart';

@JsonSerializable()
class Spe extends BaseEntity {
  final String id;
  final String name;

  const Spe({
    required this.id,
    required this.name,
  });

  factory Spe.fromJson(Map<String, dynamic> json) => _$SpeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SpeToJson(this);
}
