import 'package:api/domain/entities/api/base_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'spe.g.dart';

@JsonSerializable()
class Spe extends BaseEntity {
  final String name;

  const Spe({
    super.id,
    required this.name,
  });

  factory Spe.fromJson(Map<String, dynamic> json) => _$SpeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SpeToJson(this);
  
  @override
  ModifierBuilder getModifierBuilder() {
    return ModifierBuilder()
      .set("name", name);
  }

  @override
  bool operator ==(Object other) {
    return other is Spe
      && other.id == id
      && other.name == name;
  }

  @override
  int get hashCode => int.parse(id?.split("")
      .where((element) => int.tryParse(element) != null)
      .join()
      .substring(0, 6) ?? "-1");
}
