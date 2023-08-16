
import 'package:api/domain/entities/api/base_entity.dart';
import 'package:api/domain/entities/api/japanimation/spe/spe.dart';
import 'package:api/domain/entities/api/japanimation/category/category.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'advertisement.g.dart';

@JsonSerializable()
class Advertisement extends BaseEntity {
  final String name;
  final Category? category;
  final Spe? spe;

  const Advertisement({
    required super.id,
    required this.name,
    required this.category,
    required this.spe,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => _$AdvertisementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdvertisementToJson(this);
}
