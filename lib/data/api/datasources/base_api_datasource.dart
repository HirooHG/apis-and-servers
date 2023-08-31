
import 'package:api/data/mongo_handler.dart';
import 'package:api/domain/entities/api/base_entity.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Type;

abstract class BaseApiDataSource {
  final MongoHandler mongoHandler;

  BaseApiDataSource({
    required this.mongoHandler
  });

  Map<Type, String> getCollections();

  Future<List<Map<String, dynamic>>> get<T extends BaseEntity>() async {
    final DbCollection collection = getCollection<T>();
    return await collection.find().toList();
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

  Future<bool> put<T extends BaseEntity>(T entity) async {
    final DbCollection collection = getCollection<T>();
    final result = await collection.updateOne(
      where.eq("_id", entity.id),
      entity.getModifierBuilder()
    );
    return result.ok == 1.0;
  }

  Future<bool> patch<T extends BaseEntity>(T entity) async {
    final DbCollection collection = getCollection<T>();
    final result = await collection.updateOne(
      where.eq("_id", entity.id),
      entity.getModifierBuilder()
    );
    return result.ok == 1.0;
  }

  DbCollection getCollection<T extends BaseEntity>() => mongoHandler.getCollection(getCollections()[T]!);
}
