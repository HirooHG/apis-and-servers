
import 'dart:io';

import 'package:multigamewebsocketsdart/handlers/handler.dart';

class ApiHandler extends Handler {
  ApiHandler({
    required this.req
  });

  final HttpRequest req;
}