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

function checkTouches(e) {
  if (e.touches && e.touches.length>0) {
    e.x = e.touches[0].pageX;
    e.y = e.touches[0].pageY;
    e.pageX = e.touches[0].pageX;
    e.pageY = e.touches[0].pageY;
    e.clientX = e.touches[0].clientX;
    e.clientY = e.touches[0].clientY;
  }
}

function boardMouseDown(e) {
  checkTouches(e);
  console.log("__1__", self.mouseData.holding, self.mouseData.type );
  switch(self.mouseData.type) {
    case 'select':
      //self.deps.Shape.deselectShape();
      break;
    case 'draw':
      self.deps.Shape.createShape(e);
      break;
  }
  self.mouseData.holding = true;
  //e.preventDefault();
}

function boardMouseMove(e) {
  //console.log("__2__", self.mouseData.holding, self.mouseData.type );
  checkTouches(e);
  console.log("_+__", e, self.mouseData.type);
  if(self.mouseData.holding && self.mouseData.type == 'stop') {
    if(['scribbleEmpty', 'scribbleFilled'].includes(self.drawData.current)) {
      console.log("_++_", e);
      self.shapeData.shape.draw('point', e);
    }
  }
}

function boardMouseUp(e) {
  checkTouches(e);
  self.mouseData.holding = false;
  // console.log("___3_", self.mouseData.holding, self.mouseData.type );
  // console.log("_+__", e, self.mouseData.type);
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
