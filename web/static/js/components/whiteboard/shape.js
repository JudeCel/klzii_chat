import mobileScreenHelpers from '../../mixins/mobileHelpers';

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
  createShapeWithDefaultCoords
};

var whiteboardDelegate;
function init(delegate) {
  whiteboardDelegate = delegate;
  return this;
}

function loadShapes() {
  var newKeys = Object.keys(whiteboardDelegate.props.shapes);
  var newLength = newKeys.length;
  var oldKeys = Object.keys(whiteboardDelegate.shapeData.added);
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
    if(!whiteboardDelegate.props.shapes[key]) {
      deleteShape(key);
    }
  });
}

function addNewOrChange() {
  for(var id in whiteboardDelegate.props.shapes) {
    var object = whiteboardDelegate.props.shapes[id];
    var existing = whiteboardDelegate.shapeData.added[object.uid];
    if(!existing) {
      loadOne(object.event.element, object.permissions);
    }
    else if(object.event.element != existing.svg()) {
      existing.parent().remove();
      loadOne(object.event.element, object.permissions);
    }
  }
}

function loadOne(data, permissions) {
  var nested = whiteboardDelegate.mainGroup.nested();
  nested.svg(data);
  initShapeEvents(nested.first(), permissions);
}

function createShape(e) {
  if(e) {
    whiteboardDelegate.shapeData.shape = buildShape(e);
    if(whiteboardDelegate.shapeData.shape) {
      whiteboardDelegate.shapeData.shape.on('drawstop', whiteboardDelegate.deps.Events.shapeWasCreated);
      initShapeEvents(whiteboardDelegate.shapeData.shape);
    }
  }
}

function createShapeWithDefaultCoords() {
  whiteboardDelegate.shapeData.shape = buildShape();
  if(whiteboardDelegate.shapeData.shape) {
    whiteboardDelegate.shapeData.shape.on('drawstop', whiteboardDelegate.deps.Events.shapeWasCreated);
    initShapeEvents(whiteboardDelegate.shapeData.shape);
    whiteboardDelegate.shapeData.shape.draw('stop');
  }
}


function initShapeEvents(shape, permissions) {
  whiteboardDelegate.shapeData.added[shape.id()] = shape;

  if (permissions && permissions.can_edit) {
    shape.mousedown(selectShape);
    shape.touchstart(selectShape);
    shape.on('resizestart', whiteboardDelegate.deps.Events.shapeWillUpdate);
    shape.on('resizedone', whiteboardDelegate.deps.Events.shapeWasUpdated);
    shape.on('dragstart', whiteboardDelegate.deps.Events.shapeWillUpdate);
    shape.on('dragend', whiteboardDelegate.deps.Events.shapeWasUpdated);
  }
}

function buildShape(e) {
  var element = whiteboardDelegate.deps.Elements.shapes[whiteboardDelegate.drawData.current];
  if(element) {
    var nested = whiteboardDelegate.mainGroup.nested();
    var attrs = { fill: whiteboardDelegate.drawData.color, 'stroke-width': whiteboardDelegate.drawData.strokeWidth, stroke: whiteboardDelegate.drawData.color };
    var build = element(e, nested, attrs);
    if (!e) {
      build.center(whiteboardDelegate.drawData.initialWidth/2, whiteboardDelegate.drawData.initialHeight/2);
    }

    attrs.id = nested.id() + build.type + Date.now();
    return build.attr(attrs);
  }
}

function scaleFactor() {
  return mobileScreenHelpers.isMobile() ? 5 : 1;
}

function selectShape(e) {
  if(whiteboardDelegate.mouseData.type == 'select') {
    var shape = e.target.instance;
    var selected = whiteboardDelegate.mouseData.selected;

    if(shape && (!selected || selected && selected.id() != shape.id())) { // IE fix
      deselectShape();
      whiteboardDelegate.mouseData.selected = shape
        .selectize({ radius: 10 * scaleFactor() })
        .resize(whiteboardDelegate.drawData.minsMaxs)
        .draggable();
      whiteboardDelegate.mouseData.selected.remember('_draggable').start(e);
      _moveSelectizeToParent();
    }
  }
}

function deselectShape() {
  if(whiteboardDelegate.mouseData.selected) {
    whiteboardDelegate.mouseData.selected.selectize(false).resize('stop').draggable(false);
    whiteboardDelegate.mouseData.selected = null;
  }
}

function deleteShape(id) {
  whiteboardDelegate.shapeData.added[id].parent().remove();
  delete whiteboardDelegate.shapeData.added[id];
}

function deleteAllShapes() {
  whiteboardDelegate.mainGroup.clear();
  whiteboardDelegate.shapeData.added = {};
}

function setMouseType(type) {
  whiteboardDelegate.mouseData.prevType = whiteboardDelegate.mouseData.type;
  whiteboardDelegate.mouseData.type = type;
}

function _moveSelectizeToParent() {
  let selectize = whiteboardDelegate.mouseData.selected.remember('_selectHandler').nested;
  whiteboardDelegate.mainGroup.add(selectize);
}
