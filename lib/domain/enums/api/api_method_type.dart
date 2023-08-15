
import 'package:api/domain/extension/list_ext.dart';

enum ApiMethodType {
  get,
  post,
  delete,
  patch,
  put;

  static ApiMethodType? getType(String name) {
    return ApiMethodType.values.nullWhere((type) => type.name.toUpperCase() == name.toUpperCase());
  }
}
