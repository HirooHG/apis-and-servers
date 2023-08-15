
import 'package:api/domain/entities/api/base_entity.dart';
import 'package:api/domain/entities/api/japanimation/spe/spe.dart';
import 'package:api/domain/entities/api/japanimation/category/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'advertisement.g.dart';

@JsonSerializable()
class Advertisement extends BaseEntity {

  final String id;
  final String name;
  final Category? category;
  final Spe? spe;

  const Advertisement({
    required this.id,
    required this.name,
    required this.category,
    required this.spe,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => _$AdvertisementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdvertisementToJson(this);
}
