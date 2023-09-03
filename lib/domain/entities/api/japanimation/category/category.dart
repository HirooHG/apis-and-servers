import 'package:api/domain/entities/api/base_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends BaseEntity {
  final String name;

  const Category({
    super.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  ModifierBuilder getModifierBuilder() {
    return ModifierBuilder()
      .set("name", name);
  }

  @override
  bool operator ==(Object other) {
    return other is Category
      && other.id == id
      && other.name == name;
  }

  @override
  int get hashCode => int.parse(id?.split("")
      .where((element) => int.tryParse(element) != null)
      .join()
      .substring(0, 6) ?? "-1");
}
