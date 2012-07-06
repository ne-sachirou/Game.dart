#library('MainScenes');

#import('Game/game_all.dart');
#import('dart:html');
#import('MainScene.dart');

class FirstScene extends Scene {
  ShapeRect rect;
  ShapeText startText;

  FirstScene() {
    on.load.add(onLoad);
    on.unload.add(onUnLoad);
  }

  rectOnMouseOver(GameMouseEvent evt) => rect.fillStyle = 'red';

  rectOnMouseOut(GameMouseEvent evt) => rect.fillStyle = 'orange';

  rectOnClick(GameMouseEvent evt) {
    int v = 0;
    var timerID;
    rect.on.mouseOver.remove(rectOnMouseOver);
    rect.on.mouseOut.remove(rectOnMouseOut);
    timerID = window.setInterval(() {
      if (v >= 255) {
        window.clearInterval(timerID);
        parent.loadScene(new MainScene());
      } else {
        rect.fillStyle = 'rgb(255, $v, $v)';
        v += 8;
      }
    }, 1000 ~/ parent.fps);
  }

  void onLoad() {
    rect = new ShapeRect(0, 0, parent.width, parent.height);
    startText = new ShapeText('Start', parent.width ~/ 2, parent.height ~/ 2, '60px sans-serif');
    rect.fillStyle = 'orange';
    rect.on.mouseOver.add(rectOnMouseOver);
    rect.on.mouseOut.add(rectOnMouseOut);
    rect.on.click.add(rectOnClick);
    startText.fillStyle = 'white';
    startText.textAlign = 'center';
    appendChild(rect);
    appendChild(startText);
  }

  void onUnLoad() {
    parent.context.clearRect(0, 0, parent.width, parent.height);
  }
}
