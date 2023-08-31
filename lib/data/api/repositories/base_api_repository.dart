
import 'dart:convert';

import 'package:api/data/api/datasources/base_api_datasource.dart';
import 'package:api/domain/entities/api/base_entity.dart';

class BaseApiRepository {
  final BaseApiDataSource dataSource;

  const BaseApiRepository({
    required this.dataSource
  });

  Future<List<String>> get<T extends BaseEntity>() async {
    return (await dataSource.get<T>()).map((e) => jsonEncode(e)).toList();
  }

  Future<bool> post<T extends BaseEntity>(T entity) async {
    return await dataSource.post<T>(entity);
  }
  
  Future<bool> delete<T extends BaseEntity>(T entity) async {
    return await dataSource.delete<T>(entity);
  }
  
  Future<bool> put<T extends BaseEntity>(T entity) async {
    return await dataSource.put<T>(entity);
  }
}
