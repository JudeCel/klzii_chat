module.exports = {
  init,
  boardMouseDown,
  boardMouseMove,
  boardMouseUp,
  shapeWasCreated,
  shapeWillUpdate,
  shapeWasUpdated
};

var self;
function init(data) {
  self = data;
  return this;
}

function boardMouseDown(e) {
  self.mouseData.holding = true;

  switch(self.mouseData.type) {
    case 'select':
      self.deps.Shape.deselectShape();
      break;
    case 'draw':
      self.deps.Shape.createShape(e);
      break;
  }

  e.preventDefault();
}

function boardMouseMove(e) {
  if(self.mouseData.holding && self.mouseData.type == 'stop') {
    if(['scribbleEmpty', 'scribbleFilled'].includes(self.drawData.current)) {
      self.shapeData.shape.draw('point', e);
    }
  }
}

function boardMouseUp(e) {
  self.mouseData.holding = false;

  switch(self.mouseData.type) {
    case 'draw':
      if(self.shapeData.shape.draw) {
        self.shapeData.shape.draw(e);
      }
      break;
    case 'stop':
      self.shapeData.shape.draw('stop', e);
      self.deps.Shape.setMouseType(self.mouseData.prevType);
      break;
  }
}

function shapeWasCreated(e) {
  var shape = e.target.instance;
  self.deps.History.add(shape, 'draw');
  self.deps.Actions.shapeCreate(_shapeParams(shape));
}

function shapeWillUpdate(e) {
  var shape = e.target.instance;
  self.deps.History.add(shape, 'update', 'start');
}

function shapeWasUpdated(e) {
  var shape = e.target.instance;
  if(self.deps.History.last('undo').element == shape.svg()) {
    self.deps.History.remove('undo');
  }
  else {
    self.deps.History.add(shape, 'update', 'end');
    self.deps.Actions.shapeUpdate(_shapeParams(shape));
  }
}

function _shapeParams(shape) {
  return self.deps.Helpers.shapeParams(shape);
}
