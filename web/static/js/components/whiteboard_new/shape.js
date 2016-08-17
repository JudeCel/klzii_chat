module.exports = {
  init,
  createShape,
  loadShapes,
  buildShape,
  finishPolyShape,
  selectShape,
  deselectShape,
  setMouseType,
};

var self;
function init(data) {
  self = data;
  return this;
}

function loadShapes() {
  for(var id in self.props.shapes) {
    var object = self.props.shapes[id];

    if(!self.shapeData.added[object.uid]) {
      var nested = self.board.nested();
      nested.svg(object.event.element);
      var shape = nested.first();
      initShapeEvents(shape);
    }
  }
}

function createShape(e) {
  if(e.buttons == 1) {
    self.shapeData.shape = buildShape(e);
    self.shapeData.shape.on('drawstop', self.deps.Events.shapeDrawFinish);
    initShapeEvents(self.shapeData.shape);
  }
}

function initShapeEvents(shape) {
  self.shapeData.added[shape.id] = shape;
  shape.mousedown(selectShape);
}

// TODO: refactor
function buildShape(e) {
  var build;
  var nested = self.board.nested();
  var attrs = { fill: self.drawData.color, 'stroke-width': 3, stroke: self.drawData.color };

  switch(self.drawData.current) {
    case 'circle':
      build = nested.circle().draw(e);
      break;
    case 'ellipse':
      build = nested.ellipse().draw(e);
      break;
    case 'rect':
      build = nested.rect().draw(e);
      break;
    case 'polygon':
      attrs['pointer-events'] = 'all';
      setMouseType('point');
      build = nested.polygon().draw(e);
      break;
    case 'polyline':
      attrs.fill = 'none';
      attrs['pointer-events'] = 'all';
      setMouseType('point');
      build = nested.polyline().draw(e);
      break;
    case 'line':
      build = nested.line(0, 0, 0, 0).draw(e);
      break;
    case 'scribble':
      attrs.fill = 'none';
      attrs['pointer-events'] = 'all';
      setMouseType('stop');
      build = nested.polyline().draw(e);
      build.remember("_paintHandler").drawCircles = function() {};
      break;
    default:
      console.error('Shape not supported -', self.drawData.current);
      build = nested.rect().draw(e);
  }

  return build.attr(attrs);
}

function finishPolyShape(e) {
  if(e.buttons == 2) {
    self.shapeData.shape.draw('done', e);
    self.board.on('contextmenu', function(ev) {
      self.board.off('contextmenu');
      ev.preventDefault();
      setMouseType('select');
      self.shapeData.shape;
    });
  }
}

function selectShape(e) {
  if(self.mouseData.type == 'select') {
    deselectShape();
    self.mouseData.selected = e.target.instance.selectize().resize().draggable();
    self.mouseData.selected.remember('_draggable').start(e);
  }
}

function deselectShape() {
  if(self.mouseData.selected) {
    self.mouseData.selected.selectize(false).resize('stop').draggable(false);
    self.mouseData.selected = null;
  }
}

function setMouseType(type) {
  self.mouseData.prevType = self.mouseData.type;
  self.mouseData.type = type;
}
