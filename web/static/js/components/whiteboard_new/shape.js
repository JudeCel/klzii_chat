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
    var existing = self.shapeData.added[object.uid];

    if(!existing) {
      loadOne(object);
    }
    else if(object.event.element != existing.svg()) {
      existing.parent().remove();
      loadOne(object);
    }
  }
}

function loadOne(object) {
  var nested = self.board.nested();
  nested.svg(object.event.element);
  initShapeEvents(nested.first());
}

function createShape(e) {
  if(e.buttons == 1) {
    self.shapeData.shape = buildShape(e);
    if(self.shapeData.shape) {
      self.shapeData.shape.on('drawstop', self.deps.Events.shapeDrawFinish);
      initShapeEvents(self.shapeData.shape);
    }
    else {
      console.error("Shape is not found:", self.drawData.current);
    }
  }
}

function initShapeEvents(shape) {
  self.shapeData.added[shape.id()] = shape;
  shape.mousedown(selectShape);
  shape.on('resizedone', self.deps.Events.shapeUpdate);
  shape.on('dragend', self.deps.Events.shapeUpdate);
}

function buildShape(e) {
  var element = self.deps.Elements.shapes[self.drawData.current];

  if(element) {
    var nested = self.board.nested();
    var attrs = { fill: self.drawData.color, 'stroke-width': self.drawData.strokeWidth, stroke: self.drawData.color };
    var build = element(e, nested, attrs);
    attrs.id = nested.id() + build.type + Date.now();
    return build.attr(attrs);
  }
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
