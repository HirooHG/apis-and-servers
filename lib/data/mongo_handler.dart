
import 'package:api/server/middleware/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoHandler {

  late final Db _db;

  static final MongoHandler _mongoHandler = MongoHandler._internal();

  factory MongoHandler() {
    return _mongoHandler;
  }

  MongoHandler._internal();

  Future<void> init() async {
    _db = Db("mongodb://$mongoAddress:$mongoPort");
    await _db.open();
  }

  DbCollection getCollection(String name) {
    return _db.collection(name);
  }
}
