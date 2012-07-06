//#import('game_all.dart');
//#import('dart:html');

class Shape extends GameEntity {
  int lineWidth;
  String fillStyle, strokeStyle, lineJoin;

  Shape() : super();
}

class ShapeRect extends Shape {
  int startX, startY, width, height;

  bool hasPoint(int x, int y) =>
      (startX <= x && x <= startX + width) &&
      (startY <= y && y <= startY + height);

  void draw() {
    var context = game.context;
    if (lineWidth != null) context.lineWidth = lineWidth;
    if (fillStyle != null) context.fillStyle = fillStyle;
    if (strokeStyle != null) context.strokeStyle = strokeStyle;
    if (lineJoin != null) context.lineJoin = lineJoin;
    context.fillRect(startX, startY, width, height);
  }

  ShapeRect(this.startX, this.startY, this.width, this.height) : super();
}

class ShapeText extends Shape {
  int startX, startY, maxWidth;
  String text, font, textAlign, textBaseline;

  int get width() => maxWidth != null ? maxWidth : game.context.measureText(text).width;

  Future<int> get height() {
    var node = new Element.html('<div>$text</div>');
    node.style.font = font;
    return node.computedStyle.transform((style) => new Future.immediate(style.height));
  }

  bool hasPoint(int x, int y) =>
      (startX <= x && x <= startX + width) &&
      (startY <= y && y <= startY + game.context.fontSize);

  void draw() {
    var context = game.context;
    if (font != null) context.font = font;
    if (textAlign != null) context.textAlign = textAlign;
    if (textBaseline != null) context.textBaseline = textBaseline;
    if (fillStyle != null) context.fillStyle = fillStyle;
    game.context.fillText(text, startX, startY, maxWidth);
  }

  ShapeText(this.text, this.startX, this.startY, [this.font]) : super();
}