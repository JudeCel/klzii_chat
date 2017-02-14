module.exports = {
  init,
  boardMouseDown,
  boardMouseMove,
  boardMouseUp,
  boardMouseLeave,
  shapeWasCreated,
  shapeWillUpdate,
  shapeWasUpdated
};

var whiteboardDelegate;
function init(data) {
  whiteboardDelegate = data;
  return this;
}

function boardMouseDown(e) {
  whiteboardDelegate.mouseData.holding = true;
  switch(whiteboardDelegate.mouseData.type) {
    case 'select':
      whiteboardDelegate.deps.Shape.deselectShape();
      break;
    case 'draw':
      whiteboardDelegate.deps.Shape.createShape(e);
      whiteboardDelegate.deps.Shape.handler = whiteboardDelegate.shapeData.shape.remember('_paintHandler');
      break;
  }
}

function boardMouseMove(e) {
  if(whiteboardDelegate.mouseData.holding && whiteboardDelegate.mouseData.type == 'stop') {
    if(['scribbleEmpty', 'scribbleFilled'].includes(whiteboardDelegate.drawData.current)) {
      whiteboardDelegate.shapeData.shape.remember('_paintHandler', whiteboardDelegate.deps.Shape.handler);
      whiteboardDelegate.shapeData.shape.draw('point', e);
    }
  }
}

function boardMouseUp(e) {
  whiteboardDelegate.mouseData.holding = false;
  switch(whiteboardDelegate.mouseData.type) {
    case 'draw':
      if(whiteboardDelegate.shapeData.shape.draw) {
        whiteboardDelegate.shapeData.shape.draw(e);
      }
      break;
    case 'stop':
      whiteboardDelegate.shapeData.shape.draw('stop', e);
      whiteboardDelegate.deps.Shape.setMouseType(whiteboardDelegate.mouseData.prevType);
      break;
  }
}

function boardMouseLeave(e) {
  var category = whiteboardDelegate.drawData.category === 'poly';
  if(category && whiteboardDelegate.shapeData.shape && whiteboardDelegate.mouseData.holding) {
    boardMouseUp(e);
  }
}

function shapeWasCreated(e) {
  var shape = e.target.instance;
  whiteboardDelegate.deps.History.add(shape, 'draw');
  whiteboardDelegate.deps.Actions.shapeCreate(_shapeParams(shape));
}

function shapeWillUpdate(e) {
  var shape = e.target.instance;
  whiteboardDelegate.deps.History.add(shape, 'update', 'start');
}

function shapeWasUpdated(e) {
  var shape = e.target.instance;
  if(whiteboardDelegate.deps.History.last('undo').element == shape.svg()) {
    whiteboardDelegate.deps.History.remove('undo');
  }
  else {
    whiteboardDelegate.deps.History.add(shape, 'update', 'end');
    whiteboardDelegate.deps.Actions.shapeUpdate(_shapeParams(shape));
  }
}

function _shapeParams(shape) {
  return whiteboardDelegate.deps.Helpers.shapeParams(shape);
}
