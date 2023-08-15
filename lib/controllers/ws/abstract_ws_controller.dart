
import 'dart:io';

import 'package:api/controllers/abstract_controller.dart';

abstract class AbstractWsController extends AbstractController {
  const AbstractWsController({
    required this.socket,
    required super.request,
    required super.authProvider
  });

  void listenToChannel() {
    socket.listen(
      internal,
      onDone: onDone,
      onError: onError
    );
  }

  final WebSocket socket;

  void onDone();
  void onError(error);
  void internal(message);
}
