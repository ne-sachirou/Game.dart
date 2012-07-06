//#import('game_all.dart');
//#import('dart:html');

interface GameEventTarget {
  GameEvents get on();
  void addEventListener(String type, Function callback, [bool useCapture]);
  void removeEventListener(String type, Function callback, [bool useCapture]);
  void callEventListener(GameEvent evt);
}

class GameEventListenerList {
  final GameEventTarget _ptr;
  final String _type;

  GameEventListenerList(this._ptr, this._type);

  GameEventListenerList add(Function callback, [bool useCapture]) {
    _ptr.addEventListener(this._type, callback, useCapture);
    return this;
  }

  GameEventListenerList remove(Function callback, [bool useCapture]) {
    _ptr.removeEventListener(this._type, callback, useCapture);
    return this;
  }
}

class GameEvents {
  final GameEventTarget _ptr;
  GameEventListenerList get load() => new GameEventListenerList(_ptr, 'load');
  GameEventListenerList get unload() => new GameEventListenerList(_ptr, 'unload');
  GameEventListenerList get mouseOver() => new GameEventListenerList(_ptr, 'mouseOver');
  GameEventListenerList get mouseOut() => new GameEventListenerList(_ptr, 'mouseOut');
  GameEventListenerList get mouseMove() => new GameEventListenerList(_ptr, 'mouseOut');
  GameEventListenerList get mouseDown() => new GameEventListenerList(_ptr, 'mouseDown');
  GameEventListenerList get mouseUp() => new GameEventListenerList(_ptr, 'mouseUp');
  GameEventListenerList get click() => new GameEventListenerList(_ptr, 'click');
  GameEventListenerList get keyDown() => new GameEventListenerList(_ptr, 'keyDown');
  GameEventListenerList get keyUp() => new GameEventListenerList(_ptr, 'keyUp');
  GameEventListenerList get keyPress() => new GameEventListenerList(_ptr, 'keyPress');

  GameEvents(this._ptr);
}

class GameEvent {
  String type;
  /** Capturing pahse=1, just target=2, bubbling phase=3 */
  int eventPhase;
  final GameEventTarget target;
  GameEventTarget currentTarget;
  GameEvent(this.type, this.eventPhase, this.target, this.currentTarget);
}

class GameMouseEvent extends GameEvent {
  /** Left button=0, middle button=1, right button=2 */
  final int button;
  /** Current mouse X and Y */
  final int mouseX, mouseY;
  /** Previous mouse X and Y */
  final int pmouseX, pmouseY;
  final bool altKey, ctrlKey, metaKey, shiftKey;
  GameMouseEvent(String type, int eventPhase,
    GameEventTarget target, GameEventTarget currentTarget,
    this.mouseX, this.mouseY, this.pmouseX, this.pmouseY,
    this.button, this.altKey, this.ctrlKey, this.metaKey, this.shiftKey) :
      super(type, eventPhase, target, currentTarget);
  GameMouseEvent.fromEvent(String type, int eventPhase,
    GameEventTarget target, GameEventTarget currentTarget,
    int this.mouseX, int this.mouseY, int this.pmouseX, int this.pmouseY,
    MouseEvent event) :
      this.button = event.button,
      this.altKey = event.altKey,
      this.ctrlKey = event.ctrlKey,
      this.metaKey = event.metaKey,
      this.shiftKey = event.metaKey,
      super(type, eventPhase, target, currentTarget);
}

class GameKeyboardEvent extends GameEvent {
  final bool altGraphKey, altKey, ctrlKey, metaKey, shiftKey;
  final String keyIdentifier;
  final int keyLocation;
  GameKeyboardEvent(String type, int eventPhase,
    GameEventTarget target, GameEventTarget currentTarget,
    this.altGraphKey, this.altKey, this.ctrlKey, this.metaKey, this.shiftKey,
    this.keyIdentifier,
    this.keyLocation) :
      super(type, eventPhase, target, currentTarget);
  GameKeyboardEvent.fromEvent(String type, int eventPhase,
    GameEventTarget target, GameEventTarget currentTarget,
    KeyboardEvent event) :
      this.altGraphKey = event.altGraphKey,
      this.altKey = event.altKey,
      this.ctrlKey = event.ctrlKey,
      this.metaKey = event.metaKey,
      this.shiftKey = event.shiftKey,
      this.keyIdentifier = event.keyIdentifier,
      this.keyLocation = event.keyLocation,
      super(type, eventPhase, target, currentTarget);
}