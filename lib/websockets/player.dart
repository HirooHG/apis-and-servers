
abstract class Player {
  String id;
  String name;

  Player({required this.name, required this.id});

  String toJson();
}