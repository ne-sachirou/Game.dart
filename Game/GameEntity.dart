//#import('game_all.dart');

abstract class GameEntity extends GameNode {
  List<GameEntity> children;
  // Scene|Entity parent;
  abstract void draw();

  Game get game() {
    var node = parent;
    while (!(node is Game)) node = node.parent;
    return node;
  }
}
