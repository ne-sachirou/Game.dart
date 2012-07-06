//#import('game_all.dart');

class Group extends GameEntity {
  List<GameEntity> children;
  // Group|Scene parent;

  bool hasPoint(int x, int y) =>
      children.some((child) => child.hasPoint(x, y));

  void draw() {
    children.forEach((child) => child.draw());
  }

  Group() : super();
}
