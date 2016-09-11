module.exports = {
  init,
  shapeParams
};

var self;
function init(data) {
  self = data;
  return this;
}

function shapeParams(shape) {
  return { id: shape.id(), element: shape.svg() };
}
