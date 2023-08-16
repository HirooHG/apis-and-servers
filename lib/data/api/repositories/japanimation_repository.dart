
import 'dart:convert';

import 'package:api/data/api/datasources/japanimation_datasource.dart';
import 'package:api/domain/entities/api/base_entity.dart';

class JapanimationRepository {
  final JapanimationDatasource dataSource;

  const JapanimationRepository({required this.dataSource});

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
