
import 'dart:io';

abstract class AbstractWsController {
  AbstractWsController({
    required this.socket,
    required this.req,
  });

  void listenToChannel() {
    socket.listen(
      internal,
      onDone: onDone,
      onError: onError
    );
  }

  final WebSocket socket;
  final HttpRequest req;

  void onDone();
  void onError(error);
  void internal(message);
}
