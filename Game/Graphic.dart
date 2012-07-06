//#import('game_all.dart');

class Graphic extends GameEntity {
  List get children() => [];
  Sprite sprite;
  int drawX, drawY, drawWidth, drawHeight;

  bool hasPoint(int x, int y) =>
      (drawX <= x && x <= drawX + drawWidth) &&
      (drawY <= y && y <= drawY + drawHeight);

  void draw() {
    sprite.draw(game.context, drawX, drawY, drawWidth, drawHeight);
  }

  Graphic(this.sprite, this.drawX, this.drawY,
    [this.drawWidth, this.drawHeight]) : super() {
    if (drawWidth == null) drawWidth = sprite.spriteWidth;
    if (drawHeight == null) drawHeight = sprite.spriteHeight;
  }
}
