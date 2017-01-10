import Actions from '../../actions/whiteboard';

module.exports = {
  init,
  shapeCreate,
  shapeUpdate,
  shapeDelete,
  shapeDeleteAll,
  undoShapeDelete
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

function undoShapeDelete(shapeObject) {
  var shape = SVG.get(shapeObject.id);
  shapeDelete(shape);
}

function shapeDelete(shape) {
  if(shape) {
    var id = shape.id();
    const { dispatch, channel } = self.props;

    shape.selectize(false);
    dispatch(Actions.delete(channel, id));
  }
}

function shapeDeleteAll() {
  const { dispatch, channel } = self.props;
  dispatch(Actions.deleteAll(channel));
}
