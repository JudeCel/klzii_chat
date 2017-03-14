import Actions from '../../actions/whiteboard';

export default {
  init,
  shapeCreate,
  shapeUpdate,
  shapeDelete,
  shapeDeleteAll
};

var whiteboardDelegate;
function init(data) {
  whiteboardDelegate = data;
  return this;
}

function shapeCreate(params) {
  const { dispatch, channel } = whiteboardDelegate.props;
  dispatch(Actions.create(channel, params));
}

function shapeUpdate(params) {
  const { dispatch, channel } = whiteboardDelegate.props;
  dispatch(Actions.update(channel, params));
}

function shapeDelete(shape) {
  if(shape) {
    var id = shape.id();
    const { dispatch, channel } = whiteboardDelegate.props;

    shape.selectize(false);
    dispatch(Actions.delete(channel, id));
  }
}

function shapeDeleteAll() {
  const { dispatch, channel } = whiteboardDelegate.props;
  dispatch(Actions.deleteAll(channel));
}
