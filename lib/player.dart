
class Player {

  static Player player = Player._internal();

  factory Player() {
    return player;
  }

  Player._internal();
}