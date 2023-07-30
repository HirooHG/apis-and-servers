
import 'package:mongo_dart/mongo_dart.dart';

abstract class MongoHandler {

  static late Db _db;

  static Future<void> init() async {
    _db = Db("mongodb://localhost:27017");
    await _db.open();
  }

  static DbCollection getCollection(String name) {
    return _db.collection(name);
  }
}
