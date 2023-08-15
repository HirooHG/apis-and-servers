
import 'dart:convert';

import 'package:api/data/api/datasources/japanimation_datasource.dart';

class JapanimationRepository {
  final JapanimationDatasource dataSource;

  const JapanimationRepository({required this.dataSource});

  Future<List<String>> getAdvertisements() async {
    return (await dataSource.getAdvertisement()).map((e) => jsonEncode(e.toJson())).toList();
  }

  Future<List<String>> getSpes() async {
    return (await dataSource.getSpes()).map((e) => jsonEncode(e.toJson())).toList();
  }

  Future<List<String>> getCategories() async {
    return (await dataSource.getCategories()).map((e) => jsonEncode(e.toJson())).toList();
  }
}
