
import 'package:api/server/middleware/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_token.g.dart';

@JsonSerializable()
class UserToken {

  final String name;
  final String pwd;
  final List<Audience> audiences;

  const UserToken({
    required this.name,
    required this.pwd,
    required this.audiences,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) => _$UserTokenFromJson(json);

  Map<String, dynamic> toJson() => _$UserTokenToJson(this);
}
