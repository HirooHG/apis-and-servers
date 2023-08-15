import 'dart:convert';
import 'package:crypto/crypto.dart';

class Hash {

  static final Hash _singleton = Hash._internal();

  factory Hash() {
    return _singleton;
  }

  Hash._internal();

  final Utf8Encoder _encoder = const Utf8Encoder();

  List<int> _convert(String x) => _encoder.convert(x);

  String create (String str) => sha256.convert(_convert(str)).toString();
}
