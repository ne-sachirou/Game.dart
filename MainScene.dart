#library('MainScenes');

#import('Game/game_all.dart');
#import('dart:html');

class MainScene extends Scene {
  Function stop;
  Map<String, Sprite> faceSprites;
  Xorshift xor600, xor800;
  List<Face> liveFaces, dieFaces, momongaFaces;

  // For remove(event listener) bug.
  Function bakeOnClickHandler;
  Function killOnClickHandler;
  Function momongaOnClickHandler;

  MainScene() {
    // For remove(event listener) bug. (Same as above.)
    bakeOnClickHandler = bakeOnClick;
    killOnClickHandler = killOnClick;
    momongaOnClickHandler = momongaOnClick;

    xor600 = new Xorshift.minmax(0, 600);
    xor800 = new Xorshift.minmax(0, 800);
    on.load.add(onload);
    on.unload.add(after);
  }

  void onload() {
    query('#bakeButton').on.click.add(bakeOnClickHandler);
    query('#killButton').on.click.add(killOnClickHandler);
    query('#momongaButton').on.click.add(momongaOnClickHandler);
    int audioIdx = (new Date.now().millisecond % parent.audios.getKeys().length);
    parent.audios[parent.preloadAudios[audioIdx]].play();
    ImageElement image = parent.images['images/image.png'].image;
    faceSprites = {"live": new Sprite(image, 0, 0, 16, 16),
             "die": new Sprite(image, 16, 0, 16, 16),
             "momonga": new Sprite(image, 32, 0, 16, 25)};
    liveFaces = [];
    dieFaces = [];
    momongaFaces = [];
    parent.animate(() => drawFaces());
  }

  void after() {
    stop();
    query('#bakeButton').on.click.remove(bakeOnClickHandler);
    query('#killButton').on.click.remove(killOnClickHandler);
    query('#momongaButton').on.click.remove(momongaOnClickHandler);
  }

  void bakeOnClick(MouseEvent evt) {
    liveFaces.add(new Face("live",
      (Math.random() * 800).toInt(),
      (Math.random() * 600).toInt()));
  }

  void killOnClick(MouseEvent evt) {
    if (!liveFaces.isEmpty()) {
      Face killedFace = liveFaces[(Math.random() * liveFaces.length).toInt()];
      liveFaces = liveFaces.filter((elm) => elm != killedFace);
      dieFaces.add(new Face("die", killedFace.x, killedFace.y));
    }
  }

  void momongaOnClick(MouseEvent evt) {
    momongaFaces.add(new Face("momonga",
        xor800.random(),
        xor600.random()));
  }

  void drawFaces() {
    List<Face> faces = [];
    liveFaces.forEach((Face face) {
      face.move();
      faceSprites['live'].draw(parent.context, face.x, face.y);
    });
    dieFaces.forEach((Face face) =>
        faceSprites['die'].draw(parent.context, face.x, face.y));
    momongaFaces.forEach((Face face) {
      face.move();
      faceSprites['momonga'].draw(parent.context, face.x, face.y);
    });
  }
}

class Face {
  static Xorshift xor1;
  String type;
  Sprite faceSprite;
  int x, y;
  int get minX() => 0;
  int get maxX() => 800 - faceSprite.spriteWidth;
  int get minY() => 0;
  int get maxY() => 600 - faceSprite.spriteHeight;

  Face(this.type, this.x, this.y) {
    if (xor1 == null) xor1 = new Xorshift.minmax(0, 1000);
  }

  move() {
    switch (xor1.random() % 2) {
      case 0: --x; break;
      case 1: ++x; break;
    }
    switch (xor1.random() % 2) {
      case 0: --y; break;
      case 1: ++y; break;
    }
    // if (x < minX) x = minX;
    // if (x > maxX) x = maxX;
    // if (y < minY) y = minY;
    // if (y < maxY) y = maxY;
  }
}