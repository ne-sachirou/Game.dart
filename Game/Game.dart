//#import('game_all.dart');
//#import('dart:html');

class Game extends GameNode {
  List<Scene> children;
  final CanvasElement canvas;
  final CanvasRenderingContext2D context;
  num fps = 30;
  int mouseX = 0;
  int mouseY = 0;
  int pmouseX = 0;
  int pmouseY = 0;
  List<String> preloadImages;
  List<String> preloadAudios;
  Map<String, Sprite> images;
  Map<String, AudioElement> audios;

  int _width;
  int get width() => _width;
      set width(int w) { canvas.width = w; _width = w; }

  int _height;
  int get height() => _height;
      set height(int h) { canvas.height = h; _height = h; }

  Scene get currentScene() => children[0];

  bool hasPoint(int x, int y) => true;

  Game (CanvasElement canvasArg) :
      canvas = canvasArg,
      context = canvasArg.getContext('2d'),
      super() {
    children = [];
    preloadImages = [];
    preloadAudios = [];
    images = {};
    audios = {};
  }

  void _getMousePoint (MouseEvent evt){
    pmouseX = mouseX;
    pmouseY = mouseY;
    mouseX = evt.layerX;
    mouseY = evt.layerY;
  }

  List<GameNode> _detectEndNodeFromPoint(int x, int y) {
    Function callChain;
    var chain = [currentScene];
    callChain = (node) {
      if (node.hasPoint(x, y)) {
        chain.add(node);
        node.children.forEach(callChain(node));
      }
    };
    currentScene.children.forEach(callChain);
    return chain;
  }

  void _onMouse(String type, MouseEvent evt) {
    _getMousePoint(evt);
    var chain = _detectEndNodeFromPoint(mouseX, mouseY);
    var gameEvent = new GameMouseEvent.fromEvent(type, 1, chain.last(), this,
      mouseX, mouseY, pmouseX, pmouseY, evt);
    callEventListener(gameEvent);
    chain.forEach((node) {
      gameEvent.currentTarget = node;
      if (node == gameEvent.target) gameEvent.eventPhase = 2;
      node.callEventListener(gameEvent);
    });
    gameEvent.eventPhase = 3;
    for (int i = chain.length - 2; i >= 0; --i) {
      var node = chain[i];
      gameEvent.currentTarget = node;
      node.callEventListener(gameEvent);
    }
  }

  void _onMouseOver(MouseEvent evt) => _onMouse('mouseOver', evt);

  void _onMouseMove(MouseEvent evt) {
    Function callChain;
    _getMousePoint(evt);
    List<GameNode> chain = [];
    var target = _detectEndNodeFromPoint(mouseX, mouseY).last();
    var gameEvent = new GameMouseEvent.fromEvent('mouseMove', 1, target, this,
      mouseX, mouseY, pmouseX, pmouseY, evt);
    callEventListener(gameEvent);
    callChain = (GameNode node) {
      if (!node.hasPoint(pmouseX, pmouseY) && node.hasPoint(mouseX, mouseY)) {
        gameEvent.currentTarget = node;
        gameEvent.type = 'mouseOn';
        node.callEventListener(gameEvent);
        chain.add(node);
        node.children.forEach(callChain);
      } else if (node.hasPoint(pmouseX, pmouseY) && !node.hasPoint(mouseX, mouseY)) {
        gameEvent.currentTarget = node;
        gameEvent.type = 'mouseOut';
        node.callEventListener(gameEvent);
        chain.add(node);
        node.children.forEach(callChain);
      } else if (node.hasPoint(mouseX, mouseY)) {
        gameEvent.currentTarget = node;
        gameEvent.type = 'mouseMove';
        node.callEventListener(gameEvent);
        chain.add(node);
        node.children.forEach(callChain);
      }
    };
    children.forEach(callChain);
  }

  void _onMouseOut(MouseEvent evt) {
    pmouseX = mouseX;
    pmouseY = mouseY;
    var gameEvent = new GameMouseEvent.fromEvent('mouseOut', 1, currentScene, this,
      mouseX, mouseY, pmouseX, pmouseY, evt);
    callEventListener(gameEvent);
    gameEvent.currentTarget = currentScene;
    currentScene.callEventListener(gameEvent);
  }

  void _onMouseDown(MouseEvent evt) => _onMouse('mouseDown', evt);

  void _onMouseUp(MouseEvent evt) => _onMouse('mouseUp', evt);

  void _onClick(MouseEvent evt) => _onMouse('click', evt);

  void _onDoubleClick(MouseEvent evt) => _onMouse('doubleClick', evt);

  void _onKeyboard(String type, KeyboardEvent evt) {
    var gameEvent = new GameKeyboardEvent.fromEvent(type, 1, currentScene, this, evt);
    callEventListener(gameEvent);
    gameEvent.currentTarget = currentScene;
    currentScene.callEventListener(gameEvent);
  }

  void _onKeyDown(KeyboardEvent evt) => _onKeyboard('keyDown', evt);

  void _onKeyUp(KeyboardEvent evt) => _onKeyboard('keyUp', evt);

  void _onKeyPress(KeyboardEvent evt) => _onKeyboard('keyPress', evt);

  void size(num w, num h) {
    width = w;
    height = h;
  }

  Function animate(Function callback) {
    var frameCallback;
    frameCallback = () {
      context.clearRect(0, 0, width, height);
      callback();
      return true;
    };
    var timerID = window.requestAnimationFrame(frameCallback);
    return () => window.cancelAnimationFrame(timerID);
    // var timerID = window.setInterval(() {
    //   context.clearRect(0, 0, width, height);
    //   callback();
    // }, 1000 ~/ fps);
    // return () => window.clearInterval(timerID);
  }

  void start() {
    int timerID,
        i = 0;
    for (var imagePath in preloadImages) {
      var item = new ImageElement();
      ++i;
      item.on.load.add((evt) => --i);
      item.src = imagePath;
      images[imagePath] = new Sprite.fullSize(item);
    }
    for (var audioPath in preloadAudios) {
      var item = new AudioElement();
      //++i;
      item.on.load.add((evt) => --i);
      item.src = audioPath;
      audios[audioPath] = item;
    }
    timerID = window.setInterval(() {
      if (i <= 0) {
        window.clearInterval(timerID);
        canvas.on.mouseOver.add(_onMouseOver);
        canvas.on.mouseMove.add(_onMouseMove);
        canvas.on.mouseOut.add(_onMouseOut);
        canvas.on.mouseDown.add(_onMouseDown);
        canvas.on.mouseUp.add(_onMouseUp);
        canvas.on.click.add(_onClick);
        canvas.on.doubleClick.add(_onDoubleClick);
        document.on.keyDown.add(_onKeyDown);
        document.on.keyUp.add(_onKeyUp);
        document.on.keyPress.add(_onKeyPress);
        callEventListener(new GameEvent('load', 2, this, this));
      }
    }, 33);
  }

  void loadScene(Scene scene) {
    if (currentScene != null)
      currentScene.callEventListener(new GameEvent('unLoad', 2, currentScene, currentScene));
    children[0] = scene;
    scene.parent = this;
    scene.callEventListener(new GameEvent('load', 2, scene, scene));
  }

  void exit() {
    if (currentScene != null)
      currentScene.callEventListener(new GameEvent('unLoad', 2, currentScene, currentScene));
  }
}