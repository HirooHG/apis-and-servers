import 'package:api/domain/entities/api/base_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:api/server/middleware/audience.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'user_token.g.dart';

@JsonSerializable()
class UserToken extends BaseEntity {
  final String name;
  final String pwd;
  final List<Audience> audiences;

  const UserToken({
    super.id,
    required this.name,
    required this.pwd,
    required this.audiences,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) =>
      _$UserTokenFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserTokenToJson(this);

  @override
  bool operator ==(Object other) {
    return other is UserToken &&
        other.id == id &&
        other.name == name &&
        other.pwd == pwd;
  }

  List<String> get audiencesToString => audiences.map((e) => e.name).toList();

  @override
  int get hashCode => int.parse(id
          ?.split("")
          .where((element) => int.tryParse(element) != null)
          .join()
          .substring(0, 6) ??
      "-1");

  @override
  ModifierBuilder getModifierBuilder() {
    return ModifierBuilder()
        .set("name", name)
        .set("pwd", pwd)
        .set("audiences", audiencesToString);
  }
}
