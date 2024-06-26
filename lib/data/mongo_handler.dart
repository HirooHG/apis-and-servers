import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

class MongoHandler {
  late final Db _db;

  static final MongoHandler _mongoHandler = MongoHandler._internal();

  factory MongoHandler() {
    return _mongoHandler;
  }

  MongoHandler._internal();

  Future<void> init(List<String> args) async {
    if (args.isEmpty) {
      print(
          "Please provide the type of environment (docker/local) as an argument.");
      exit(1);
    }
    final mongoAddress = args.first == "docker" ? "mongo" : "localhost";
    _db = Db("mongodb://$mongoAddress:27017");
    await _db.open();
  }

  DbCollection getCollection(String name) {
    return _db.collection(name);
  }
}
