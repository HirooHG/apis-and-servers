import 'dart:io';

import 'package:multigamewebsocketsdart/requesthandler.dart';

Future<void> main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 3402);
  print("Listening on ws://${server.address.address}:${server.port}");

  await for (HttpRequest request in server) {
    var handler = await RequestHandler.init(req: request);
    if(handler == null) {
      print("cannot handle request");
    }
  }
}