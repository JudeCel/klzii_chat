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
    type: shape.type
  };

  console.log(shape);
  console.log(attrs, "params");

  return attrs;

}
