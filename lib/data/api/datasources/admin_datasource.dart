import 'package:api/data/api/datasources/base_api_datasource.dart';
import 'package:api/server/middleware/entities/user_token.dart';

class AdminDataSource extends BaseApiDataSource {
  AdminDataSource({required super.mongoHandler});

  @override
  Map<Type, String> getCollections() => {UserToken: "users"};
}
