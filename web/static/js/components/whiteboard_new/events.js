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
  //e.preventDefault();
  self.mouseData.holding = true;
  console.log("__?__", self.mouseData.type);
  switch(self.mouseData.type) {
    case 'select':
      //self.deps.Shape.deselectShape();
      break;
    case 'draw':
      self.deps.Shape.createShape(e);
      break;
  }

}

function boardMouseMove(e) {
  console.log("self.mouseData.type", self.mouseData.type);
  if(self.mouseData.holding && self.mouseData.type == 'stop') {
    if(['scribbleEmpty', 'scribbleFilled'].includes(self.drawData.current)) {
      self.shapeData.shape.draw('point', e);
    }
  }
}

function boardMouseUp(e) {
  self.mouseData.holding = false;
  console.log("finish");
  switch(self.mouseData.type) {
    case 'draw':
    console.log("self.shapeData.shape", self.shapeData.shape);
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
