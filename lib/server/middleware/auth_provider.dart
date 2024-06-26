import 'dart:io';

import 'dart:convert';
import 'package:api/data/mongo_handler.dart';
import 'package:api/common/extension/list_helper.dart';
import 'package:api/server/middleware/constants.dart';
import 'package:api/server/middleware/audience.dart';
import 'package:api/server/middleware/entities/response.dart';
import 'package:api/server/middleware/entities/user_token.dart';
import 'package:api/server/middleware/exceptions/auth_failed.dart';
import 'package:api/server/middleware/hash.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthProvider {
  static final AuthProvider _singleton = AuthProvider._internal();

  factory AuthProvider() {
    return _singleton;
  }

  AuthProvider._internal();

  final JsonDecoder _decoder = const JsonDecoder();
  final Hash _hash = Hash();
  final MongoHandler _mongoHandler = MongoHandler();

  final String fieldName = "name";
  final String fieldPwd = "pwd";

  late final _collectionUsers = _mongoHandler.getCollection("users");

  Future<Response> auth(HttpRequest request) async {
    try {
      dynamic data = _decoder.convert(await utf8.decodeStream(request));

      final userLogin = _getLoginUser(data);
      final user = await _getUser(userLogin);
      if (user == null) {
        throw AuthFailed();
      }

      final token = _getTokenClaim(user);
      return Response.ok(token);
    } catch (e) {
      return Response.forbidden('Incorrect username/password');
    }
  }

  Future<Response> verify(HttpRequest request, Audience audience) async {
    try {
      final token = _getHeaderToken(request.headers);
      JwtClaim claim = verifyJwtHS256Signature(token, secret);
      claim.validate(issuer: issuer, audience: audience.name);
      return Response.verifed();
    } catch (e) {
      return Response.forbidden('Authorization rejected: ${e.runtimeType}');
    }
  }

  String _getTokenClaim(UserToken user) {
    final JwtClaim claim = JwtClaim(
        subject: user.name,
        issuer: issuer,
        audience: user.audiencesToString,
        maxAge: tokenAge);

    return issueJwtHS256(claim, secret);
  }

  String _getHeaderToken(HttpHeaders headers) {
    final token = headers
        .value(HttpHeaders.authorizationHeader)
        ?.replaceAll("Bearer ", "");
    if (token == null) {
      throw AuthFailed();
    }
    return token;
  }

  UserToken _getLoginUser(dynamic data) {
    String name = data[fieldName];
    String pwd = data[fieldPwd];
    String hash = _hash.create(pwd);

    return UserToken(id: Uuid().v1(), name: name, pwd: hash, audiences: []);
  }

  Future<UserToken?> _getUser(UserToken user) async {
    final usersJson = await _collectionUsers.find().toList();
    final users = usersJson.map((e) => UserToken.fromJson(e)).toList();
    users.add(UserToken(
        id: Uuid().v1(),
        name: adminLogin,
        pwd: _hash.create(adminPwd),
        audiences: [Audience.admin]));
    return users.nullWhere((e) => e.name == user.name && e.pwd == user.pwd);
  }
}
