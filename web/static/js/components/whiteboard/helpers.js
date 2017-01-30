module.exports = {
  init,
  shapeParams
};

var whiteboardDelegate;
function init(data) {
  whiteboardDelegate = data;
  return this;
}

function shapeParams(shape) {
  let attrs =  {
    id: shape.id(),
    element: shape.svg(),
    type: shape.type,
    ownerId: whiteboardDelegate.props.currentUser.id,
    colour: whiteboardDelegate.props.currentUser.colour
  };

  return attrs;

}
