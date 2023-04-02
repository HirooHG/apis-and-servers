
import 'dart:convert';

class Image {
  String nom;
  String lien;

  Image({required this.nom, required this.lien});

  String toJson() {
    return jsonEncode({
      "nom": nom,
      "lien": lien
    });
  }
}