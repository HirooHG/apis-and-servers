import 'dart:io';

import 'package:api/server/middleware/auth_provider.dart';

abstract class AbstractController {
  final HttpRequest request;
  final AuthProvider authProvider;

  const AbstractController({required this.request, required this.authProvider});
  
  String? getSegment(int place) {
    try {
      return request.uri.pathSegments[place];
    } catch (e) {
      return null;
    }
  }

  void notImplemented() {
    request
      ..response.statusCode = HttpStatus.notImplemented
      ..response.close();
  }

  void forbidden() {
    request
      ..response.statusCode = HttpStatus.forbidden
      ..response.close();
  }

  void badRequest() {
    request
      ..response.statusCode = HttpStatus.badRequest
      ..response.close();
  }

  void notFound() {
    request
      ..response.statusCode = HttpStatus.notFound
      ..response.close();
  }

  void success(Object obj) {
    ContentType type = (obj is String) ? ContentType.text : ContentType.json;
    request
      ..response.statusCode = HttpStatus.ok
      ..response.headers.add(HttpHeaders.contentTypeHeader, type.value)
      ..response.write(obj.toString())
      ..response.close();
  }

  void methodNotAllowed() {
    request
      ..response.statusCode = HttpStatus.methodNotAllowed
      ..response.close();
  }
}
