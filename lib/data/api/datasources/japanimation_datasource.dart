
import 'package:api/data/mongo_handler.dart';
import 'package:api/domain/entities/api/japanimation/advertisement/advertisement.dart';
import 'package:api/domain/entities/api/japanimation/category/category.dart';
import 'package:api/domain/entities/api/japanimation/spe/spe.dart';
import 'package:mongo_dart/mongo_dart.dart';

class JapanimationDatasource {

  final String _nameCollectionAdv = "japanimation_advertisement";
  final String _nameCollectionCat = "japanimation_spe";
  final String _nameCollectionSpe = "japanimation_category";

  late final MongoHandler _mongoHandler;

  late final DbCollection _advCollection;
  late final DbCollection _catCollection;
  late final DbCollection _speCollection;

  JapanimationDatasource() {
    _mongoHandler = MongoHandler();
    _advCollection = _mongoHandler.getCollection(_nameCollectionAdv);
    _speCollection = _mongoHandler.getCollection(_nameCollectionSpe);
    _catCollection = _mongoHandler.getCollection(_nameCollectionCat);
  }

  Future<List<Advertisement>> getAdvertisement() async {
    final list = await _advCollection.find().toList();
    return list.map((adv) => Advertisement.fromJson(adv)).toList();
  }

  Future<List<Spe>> getSpes() async {
    final list = await _speCollection.find().toList();
    return list.map((spe) => Spe.fromJson(spe)).toList();
  }

  Future<List<Category>> getCategories() async {
    final list = await _catCollection.find().toList();
    return list.map((cat) => Category.fromJson(cat)).toList();
  }
}
