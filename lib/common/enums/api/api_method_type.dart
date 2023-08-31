
import 'package:api/common/extension/list_helper.dart';

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
