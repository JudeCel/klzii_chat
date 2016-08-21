import Actions from '../../actions/whiteboard';

module.exports = {
  init,
  boardMouseDown,
  boardMouseMove,
  boardMouseUp,
  shapeDrawFinish,
  shapeUpdate,
  shapeDelete,
  shapeDeleteAll,
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
      if(e.target.id == self.board.node.id) {
        self.deps.Shape.deselectShape();
      }
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
      self.shapeData.shape.draw(e);
      break;
    case 'stop':
      self.shapeData.shape.draw('stop', e);
      self.deps.Shape.setMouseType(self.mouseData.prevType);
      break;
  }
}

function shapeDrawFinish(e) {
  const { dispatch, channel } = self.props;
  dispatch(Actions.create(channel, _shapeParams(e)));
}

function shapeUpdate(e) {
  const { dispatch, channel } = self.props;
  dispatch(Actions.update(channel, _shapeParams(e)));
}

function shapeDelete(shape) {
  if(shape) {
    var id = shape.id();
    const { dispatch, channel } = self.props;

    dispatch(Actions.delete(channel, id));
    self.deps.Shape.deleteShape(id);
  }
}

function shapeDeleteAll() {
  const { dispatch, channel } = self.props;
  dispatch(Actions.deleteAll(channel));
  self.deps.Shape.deleteAllShapes();
}

function _shapeParams(e) {
  return { id: e.target.id, element: e.target.instance.svg() };
}
