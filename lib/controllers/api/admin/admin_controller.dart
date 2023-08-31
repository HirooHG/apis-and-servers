
import 'dart:convert';

import 'package:api/common/extension/list_helper.dart';
import 'package:api/controllers/api/abstract_api_controller.dart';
import 'package:api/controllers/api/admin/enums/admin_type.dart';
import 'package:api/domain/entities/api/base_entity.dart';
import 'package:api/server/middleware/entities/user_token.dart';
import 'package:api/server/middleware/hash.dart';

class AdminController extends AbstractApiController {
  AdminController({
    required super.request,
    required super.authProvider,
    required super.repository
  });

  @override
  void get() async {
    final type = _getAdminType();

    switch(type) {
      case AdminType.users:
        final users = await repository.get<UserToken>();
        success(users);
        break;
      default:
        notFound();
        break;
    }
  }

  @override
  void post() async {
    final type = _getAdminType();
    final str = await utf8.decodeStream(request);

    try {
      final Map<String, dynamic> map = jsonDecode(str);

      switch(type) {
        case AdminType.users:
          map["pwd"] = Hash().create(map["pwd"]);
          final user = UserToken.fromJson(map);
          handlePost<UserToken>(user);
          break;
        default:
          notFound();
          break;
      }
    } catch(e) {
      badRequest();
    }
  }

  @override
  void put() async {
    final type = _getAdminType();
    final str = await utf8.decodeStream(request);

    try {
      final Map<String, dynamic> map = jsonDecode(str);

      switch(type) {
        case AdminType.users:
          final user = UserToken.fromJson(map);
          handlePut<UserToken>(user);
          break;
        default:
          notFound();
          break;
      }
    } catch(e) {
      badRequest();
    }
  }

  @override
  void delete() async {
    final type = _getAdminType();
    final str = await utf8.decodeStream(request);

    try {
      final Map<String, dynamic> map = jsonDecode(str);

      switch(type) {
        case AdminType.users:
          final user = UserToken.fromJson(map);
          handleDelete<UserToken>(user);
          break;
        default:
          notFound();
          break;
      }
    } catch(e) {
      badRequest();
    }
  }

  @override
  void patch() {
    methodNotAllowed();
  }

  Future<void> handlePost<T extends BaseEntity>(T entity) async {
    final isGood = await repository.post<T>(entity);
    verifUpdate(isGood);
  }

  Future<void> handlePut<T extends BaseEntity>(T entity) async {
    final isGood = await repository.put<T>(entity);
    verifUpdate(isGood);
  }

  Future<void> handleDelete<T extends BaseEntity>(T entity) async {
    final isGood = await repository.delete<T>(entity);
    verifUpdate(isGood);
  }

  AdminType? _getAdminType() {
    final segment = getSegment(1);
    if (segment == null) {
      return null;
    }
    return AdminType.values.nullWhere((type) => type.name == segment);
  }
}
