
import 'dart:io';

import 'package:api/controllers/gen_controller.dart';
import 'package:api/server/middleware/auth_provider.dart';
import 'package:api/server/middleware/constants.dart';

class Server {
  
  late final HttpServer _httpServer;

  Future<void> init() async {
    _httpServer = await HttpServer.bind(InternetAddress.anyIPv4, serverPort);
    print("Listening on http-ws://${_httpServer.address.address}:${_httpServer.port}");
  }

  Future<void> serve() async {
    await for (HttpRequest req in _httpServer) {
      GenController(request: req, authProvider: AuthProvider())
        .handleRequest();
    }
  }
}

// to get a certificate: https://gist.github.com/stevenroose/e6abde14258971eae982
// stack overflow info: https://stackoverflow.com/questions/27402679/how-to-create-a-secure-http-server-in-dart
