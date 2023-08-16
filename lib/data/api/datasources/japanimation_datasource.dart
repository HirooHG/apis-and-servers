
import 'package:api/data/mongo_handler.dart';
import 'package:api/domain/entities/api/base_entity.dart';
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

  Future<List<Map<String, dynamic>>> get<T extends BaseEntity>() async {
    final DbCollection collection = getCollection<T>();
    return await collection.find().toList();
  }
  
  Future<bool> put<T extends BaseEntity>(T entity) async {
    switch(entity.runtimeType) {
      case Advertisement:
        return await putAdvertisement(entity as Advertisement);
      case Category:
        return await putCategory(entity as Category);
      default:
        return await putSpe(entity as Spe);
    }
  }

  Future<bool> putCategory(Category category) async {
    final DbCollection collection = getCollection<Category>();
    final result = await collection.updateOne(
      where.eq("id", category.id),
      ModifierBuilder()
        .set("name", category.name)
    );
    return result.ok == 1.0;
  }

  Future<bool> putSpe(Spe spe) async {
    final DbCollection collection = getCollection<Spe>();
    final result = await collection.updateOne(
      where.eq("id", spe.id),
      ModifierBuilder()
        .set("name", spe.name)
    );
    return result.ok == 1.0;
  }

  Future<bool> putAdvertisement(Advertisement adv) async {
    final DbCollection collection = getCollection<Advertisement>();
    final result = await collection.updateOne(
      where.eq("id", adv.id),
      ModifierBuilder()
        .set("name", adv.name)
        .set("spe", adv.spe?.toJson())
        .set("category", adv.category?.toJson())
    );
    return result.ok == 1.0;
  }

  Future<bool> post<T extends BaseEntity>(T entity) async {
    final DbCollection collection = getCollection<T>();
    final result = await collection.insertOne(entity.toJson());
    return result.ok == 1.0;
  }

  Future<bool> delete<T extends BaseEntity>(T entity) async {
    final DbCollection collection = getCollection<T>();
    final result = await collection.deleteOne(entity.toJson());
    return result.ok == 1.0;
  }

  DbCollection getCollection<T extends BaseEntity>() {
    final DbCollection collection;
    if(T is Spe) {
      collection = _speCollection;
    } else if (T is Category) {
      collection = _catCollection;
    } else {
      collection = _advCollection;
    }
    return collection;
  }
}
