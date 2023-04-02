
import 'dart:convert';

import 'image.dart';

class Event {

  String nom;
  String description;
  Image couverture;
  DateTime date;

  Event({
    required this.nom,
    required this.description,
    required this.couverture,
    required this.date
  });

  String toJson() {
    return jsonEncode({
      "nom": nom,
      "description": description,
      "couverture": couverture.toJson(),
      "data": date.toString()
    });
  }
}