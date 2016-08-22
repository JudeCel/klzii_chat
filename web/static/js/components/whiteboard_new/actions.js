import Actions from '../../actions/whiteboard';

module.exports = {
  init,
  shapeCreate,
  shapeUpdate,
  shapeDelete,
  shapeDeleteAll,
};

var self;
function init(data) {
  self = data;
  return this;
}

function shapeCreate(params) {
  const { dispatch, channel } = self.props;
  dispatch(Actions.create(channel, params));
}

function shapeUpdate(params) {
  const { dispatch, channel } = self.props;
  dispatch(Actions.update(channel, params));
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
