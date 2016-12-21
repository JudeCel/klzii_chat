module.exports = {
  init,
  createShape,
  loadShapes,
  buildShape,
  selectShape,
  deselectShape,
  deleteShape,
  deleteAllShapes,
  loadOne,
  setMouseType,
};

var self;
function init(data) {
  self = data;
  return this;
}

function loadShapes() {
  var newKeys = Object.keys(self.props.shapes);
  var newLength = newKeys.length;
  var oldKeys = Object.keys(self.shapeData.added);
  var oldLength = oldKeys.length;

  if(!newLength && oldLength) {
    deleteAllShapes();
  }
  else if(newLength) {
    removeOld(oldKeys);
    addNewOrChange();
  }
}

function removeOld(oldKeys) {
  oldKeys.map(function(key) {
    if(!self.props.shapes[key]) {
      deleteShape(key);
    }
  });
}

function addNewOrChange() {
  for(var id in self.props.shapes) {
    var object = self.props.shapes[id];
    var existing = self.shapeData.added[object.uid];

    if(!existing) {
      loadOne(object.event.element);
    }
    else if(object.event.element != existing.svg()) {
      existing.parent().remove();
      loadOne(object.event.element);
    }
  }
}

function loadOne(data) {
  var nested = self.mainGroup.nested();
  nested.svg(data);
  initShapeEvents(nested.first());
}

function createShape(e) {
  if(e.buttons == 1 || (e.touches && e.touches.length)) {
    self.shapeData.shape = buildShape(e);
    if(self.shapeData.shape) {
      self.shapeData.shape.on('drawstop', self.deps.Events.shapeWasCreated);
      initShapeEvents(self.shapeData.shape);
    }
    else {
      console.error('Shape is not found:', self.drawData.current);
    }
  }
}

function initShapeEvents(shape) {
  self.shapeData.added[shape.id()] = shape;
  shape.mousedown(selectShape);
  shape.touchstart(selectShape);
  shape.on('resizestart', self.deps.Events.shapeWillUpdate);
  shape.on('resizedone', self.deps.Events.shapeWasUpdated);
  shape.on('dragstart', self.deps.Events.shapeWillUpdate);
  shape.on('dragend', self.deps.Events.shapeWasUpdated);
}

function buildShape(e) {
  var element = self.deps.Elements.shapes[self.drawData.current];
  if(element) {
    var nested = self.mainGroup.nested();
    var attrs = { fill: self.drawData.color, 'stroke-width': self.drawData.strokeWidth, stroke: self.drawData.color };
    var build = element(e, nested, attrs);
    attrs.id = nested.id() + build.type + Date.now();
    return build.attr(attrs);
  }
}

function scaleFactor() {
  return window.innerWidth<700 ?3:1;
}

function selectShape(e) {
  if(self.mouseData.type == 'select') {
    var shape = e.target.instance;
    var selected = self.mouseData.selected;

    if(shape && (!selected || selected && selected.id() != shape.id())) { // IE fix
      deselectShape();
      self.mouseData.selected = shape.selectize({radius: 10 * scaleFactor()}).resize(self.drawData.minsMaxs).draggable();
      self.mouseData.selected.remember('_draggable').start(e);
      _moveSelectizeToParent();
    }
  }
}

function deselectShape() {
  if(self.mouseData.selected) {
    self.mouseData.selected.selectize(false).resize('stop').draggable(false);
    self.mouseData.selected = null;
  }
}

function deleteShape(id) {
  self.shapeData.added[id].parent().remove();
  delete self.shapeData.added[id];
}

function deleteAllShapes() {
  self.mainGroup.clear();
  self.shapeData.added = {};
}

function setMouseType(type) {
  self.mouseData.prevType = self.mouseData.type;
  self.mouseData.type = type;
}

function _moveSelectizeToParent() {
  let selectize = self.mouseData.selected.remember('_selectHandler').nested;
  self.mainGroup.add(selectize);
}
