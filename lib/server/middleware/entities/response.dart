
import 'dart:io';

class Response {

  final int status;
  final String? token;
  final String? error;

  Response.ok(this.token)
    : status = HttpStatus.ok,
      error = null;

  Response.verifed()
    : status = HttpStatus.ok,
      error = null,
      token = null;

  Response.forbidden(this.error)
    : status = HttpStatus.forbidden,
      token = null;

  bool isOk() {
    return status == HttpStatus.ok;
  }

  @override
  String toString() {
    return "status: $status\ntoken: $token\nerror: $error";
  }
}
