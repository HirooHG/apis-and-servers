import 'dart:io';

import 'dart:convert';
import 'package:api/data/mongo_handler.dart';
import 'package:api/server/middleware/constants.dart';
import 'package:api/server/middleware/entities/response.dart';
import 'package:api/server/middleware/entities/user_token.dart';
import 'package:api/server/middleware/exceptions/auth_failed.dart';
import 'package:api/server/middleware/hash.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

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
  
  late final _collectionUsers = _mongoHandler.getCollection(dbUsersCollectioName);

  bool _check(Map<String, dynamic> user, Map<String, dynamic> creds) =>
    (user[fieldName] == creds[fieldName] && user[fieldPwd] == creds[fieldPwd]);

  Future<Response> auth(HttpRequest request) async {
    try {
        dynamic data = _decoder.convert(await utf8.decodeStream(request));

        String user = data[fieldName];
        String pwd = data[fieldPwd];
        String hash = _hash.create(pwd);

        final Map<String, dynamic> creds = {
          fieldName: user,
          fieldPwd: hash
        };
        final users = await _collectionUsers.find().toList();

        int index = users.indexWhere((user) => _check(user, creds));
        if (index == -1) {
          throw AuthFailed();
        }

        JwtClaim claim = JwtClaim(
          subject: user,
          issuer: issuer,
          audience: Audience.values.map((e) => e.getValue).toList(),
          maxAge: tokenAge
        );

        String token = issueJwtHS256(claim, secret);
        return Response.ok(token);
      }
      catch (e) {
        return Response.forbidden('Incorrect username/password');
      }
  }

  Future<Response> verify(HttpRequest request, Audience audience) async {
    try {
      final token = request.headers.value(HttpHeaders.authorizationHeader)?.replaceAll("Bearer ", "");
      if(token == null) {
        throw AuthFailed();
      }

      JwtClaim claim = verifyJwtHS256Signature(token, secret);
      claim.validate(
        issuer: issuer,
        audience: audience.getValue
      );
      return Response.verifed();
    }
    catch(e) {
      return Response.forbidden('Authorization rejected: ${e.runtimeType}');
    }
  }
}
