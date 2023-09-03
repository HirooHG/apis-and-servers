// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserToken _$UserTokenFromJson(Map<String, dynamic> json) => UserToken(
      id: json['_id'] as String?,
      name: json['name'] as String,
      pwd: json['pwd'] as String,
      audiences: (json['audiences'] as List<dynamic>)
          .map((e) => $enumDecode(_$AudienceEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$UserTokenToJson(UserToken instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'pwd': instance.pwd,
      'audiences':
          instance.audiences.map((e) => _$AudienceEnumMap[e]!).toList(),
    };

const _$AudienceEnumMap = {
  Audience.service: 'service',
  Audience.ws: 'ws',
  Audience.api: 'api',
  Audience.japanimation: 'japanimation',
  Audience.tictactoe: 'tictactoe',
  Audience.admin: 'admin',
};
