
import 'package:api/data/api/datasources/base_api_datasource.dart';
import 'package:api/domain/entities/api/japanimation/advertisement/advertisement.dart';
import 'package:api/domain/entities/api/japanimation/category/category.dart';
import 'package:api/domain/entities/api/japanimation/spe/spe.dart';

class JapanimationDatasource extends BaseApiDataSource {

  final String _nameCollectionAdv = "japanimation_advertisement";
  final String _nameCollectionCat = "japanimation_spe";
  final String _nameCollectionSpe = "japanimation_category";

  JapanimationDatasource({
    required super.mongoHandler
  });

  @override
  Map<Type, String> getCollections() => {
    Advertisement: _nameCollectionAdv,
    Spe: _nameCollectionSpe,
    Category: _nameCollectionCat
  };
}
