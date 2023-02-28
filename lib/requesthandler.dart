
import 'dart:io';

import 'websockethandler.dart';
import 'handler.dart';

class RequestHandler {

  const RequestHandler({
    required this.req,
    required this.handler
  });

  final HttpRequest req;
  final Handler? handler;

  static Future<RequestHandler?> init({required HttpRequest req}) async {
    if(req.uri.pathSegments.isEmpty) {
      req.response.statusCode = HttpStatus.forbidden;
      req.response.close();
      return null;
    }

    switch(req.uri.pathSegments[0]) {
      case 'ws':
        var wshandler = await WebSocketHandler.init(req: req);
        return RequestHandler(req: req, handler: wshandler);
      case 'api':

        return RequestHandler(req: req, handler: null);
      default:
        req.response.statusCode = HttpStatus.forbidden;
        req.response.close();
        return null;
    }
  }
}