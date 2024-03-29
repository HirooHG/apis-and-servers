import 'package:mongo_dart/mongo_dart.dart';

abstract class BaseEntity {
  Map<String, dynamic> toJson();

  const BaseEntity({
    this.id
  });

  final String? id;

  ModifierBuilder getModifierBuilder();
}
