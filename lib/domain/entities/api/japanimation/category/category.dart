import 'package:api/domain/entities/api/base_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends BaseEntity {
  final String id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
