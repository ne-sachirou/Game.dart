//#import('dart:html');

class Sprite {
  final ImageElement image;
  int startX, startY, spriteWidth, spriteHeight;

  Sprite(this.image, this.startX, this.startY,
         this.spriteWidth, this.spriteHeight) {
    assert(image != null);
    assert(startX >= 0);
    assert(startY >= 0);
    assert(0 <= spriteWidth && spriteWidth <= image.width);
    assert(0 <= spriteHeight && spriteHeight <= image.height);
  }

  Sprite.fullSize(this.image) {
    assert(image != null);
    startX = 0;
    startY = 0;
    spriteWidth = image.width;
    spriteHeight = image.height;
  }

  void draw(CanvasRenderingContext2D context,
            int drawX, int drawY,
            [int drawWidth, int drawHeight]) {
    if (drawWidth == null) drawWidth = spriteWidth;
    if (drawHeight == null) drawHeight = spriteHeight;
    context.drawImage(image,
      startX, startY,
      spriteWidth, spriteHeight,
      drawX, drawY,
      drawWidth, drawHeight);
  }
}
