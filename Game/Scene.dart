//#import('game_all.dart');

abstract class Scene extends GameNode {
  List<GameEntity> children;
  Game parent;
  bool hasPoint(int x, int y) => true;
  Function stopSceneAnimation;

  Scene() : super() {
    on.load.add((evt) {
      stopSceneAnimation = parent.animate(() =>
          children.forEach((child) => child.draw()));
    });
    on.unload.add((evt) => stopSceneAnimation());
  }
}