//#import('game_all.dart');

abstract class GameNode implements GameEventTarget {
  Map<String, Set<Function>> capturingListeners;
  Map<String, Set<Function>> bubblingListeners;
  List<GameNode> children;
  GameNode parent;
  GameEvents get on() => new GameEvents(this);
  abstract bool hasPoint(int x, int y);

  GameNode() {
    var eventNames = [ 'load', 'unLoad', 'mouseOver', 'mouseOut', 'mouseMove',
                       'mouseDown', 'mouseUp', 'click', 'doubleClick', 'keyDown',
                       'keyUp', 'keyPress' ];
    capturingListeners = {};
    eventNames.forEach((eventName) => capturingListeners[eventName] = new Set());
    bubblingListeners = {};
    eventNames.forEach((eventName) => bubblingListeners[eventName] = new Set());
    children = [];
  }

  void addEventListener(String type, Function callback, [bool useCapture]) {
    if (useCapture) {
      capturingListeners[type].add(callback);
    } else if (!useCapture) {
      bubblingListeners[type].add(callback);
    }
  }

  void removeEventListener(String type, Function callback, [bool useCapture]) {
    if (useCapture) {
      capturingListeners[type].remove(callback);
    } else {
      bubblingListeners[type].remove(callback);
    }
  }

  void callEventListener(GameEvent evt) {
    if (evt is GameMouseEvent) {
      if (evt.type == 'mouseOut' &&
          (hasPoint(evt.mouseX, evt.mouseY) || !hasPoint(evt.pmouseX, evt.pmouseY))) {
        return;
      } else if (!hasPoint(evt.mouseX, evt.mouseY)) {
        return;
      }
    }
    switch (evt.eventPhase) {
      case 1:
        capturingListeners[evt.type].forEach((listener) => listener(evt));
        break;
      case 2: case 3:
        bubblingListeners[evt.type].forEach((listener) => listener(evt));
        break;
    }
  }

  bool contains(GameNode node) =>
      children.some((child) => child.parent == this && child == node);

  bool hasChildNodes() => children != null && children.length != 0;

  GameNode insertBefore(GameNode newNode, GameNode referenceNode) {
    int refIndex = children.indexOf(referenceNode);
    if (refIndex != -1) children.insertRange(refIndex, 1, newNode);
    return referenceNode;
  }

  GameNode remove() {
    parent.children = parent.children.filter((child) => child == this);
    this.parent = null;
    return this;
  }

  GameNode replaceWith(GameNode node) {
    parent.children = parent.children.map((child) {
      if (child == this) return node;
      return child;
    });
    this.parent = null;
    return this;
  }

  GameNode appendChild(GameNode node) {
    children.add(node);
    node.parent = this;
    return node;
  }

  GameNode removeChild(GameNode node) {
    children = children.filter((child) => child == node);
    node.parent = null;
    return node;
  }

  GameNode replaceChild(GameNode newNode, GameNode oldNode) {
    children = children.map((child) {
      if (child == oldNode) {
        oldNode.parent = null;
        return newNode;
      }
      return child;
    });
    return oldNode;
  }
}