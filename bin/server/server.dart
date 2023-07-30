
import 'dart:io';

import 'package:multigamewebsocketsdart/controllers/gen_controller.dart';

class Server {
  
  late final HttpServer _httpServer;

  Future<void> init() async {
    _httpServer = await HttpServer.bind(InternetAddress.anyIPv4, 3402);
    print("Listening on ws://${_httpServer.address.address}:${_httpServer.port}");
  }

  Future<void> serve() async {
    await for (HttpRequest req in _httpServer) {
      GenController(request: req).handleRequest();
    }
  }
}
