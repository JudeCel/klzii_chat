import Actions from '../../actions/whiteboard';

module.exports = {
  init,
  boardMouseDown,
  boardMouseMove,
  boardMouseUp,
  shapeDrawFinish,
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
      if(e.target.id == board.node.id) {
        self.deps.Shape.deselectShape();
      }
      break;
    case 'draw':
      self.deps.Shape.createShape(e);
      break;
    case 'point':
      self.deps.Shape.finishPolyShape(e);
      break;
  }

  e.preventDefault();
}

function boardMouseMove(e) {
  if(self.mouseData.holding && self.mouseData.type == 'stop') {
    if(self.drawData.current == 'scribble') {
      self.shapeData.shape.draw('point', e);
    }
  }
}

function boardMouseUp(e) {
  self.mouseData.holding = false;

  switch(self.mouseData.type) {
    case 'draw':
      self.shapeData.shape.draw(e);
      self.deps.Shape.setMouseType('select');
      break;
    case 'point':
      self.shapeData.shape.draw('point', e);
      break;
    case 'stop':
      self.shapeData.shape.draw('stop', e);
      self.deps.Shape.setMouseType(self.mouseData.prevType);
      break;
  }
}

function shapeDrawFinish(e) {
  const { dispatch, channel } = self.props;
  dispatch(Actions.create(channel, { id: e.target.id, element: self.shapeData.shape.svg() }));
}
