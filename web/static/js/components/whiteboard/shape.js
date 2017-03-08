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
    if(whiteboardDelegate.shapeData.shape.node) {
      const id = whiteboardDelegate.shapeData.shape.node.id;
      oldKeys = oldKeys.filter((key) => key !== id);
    }

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
      loadOne(object.event.element, object.permissions, object.updatedAt);
    } else if(!existing.updatedAt) {
      existing.updatedAt = object.updatedAt;
      existing.permissions = object.permissions;
    } else if(object.updatedAt != existing.updatedAt) {
      existing.parent().remove();
      loadOne(object.event.element, object.permissions, object.updatedAt);
    }
  }
}

function loadOne(data, permissions, updatedAt) {
  var nested = whiteboardDelegate.mainGroup.nested();
  nested.svg(data);
  initShapeEvents(nested.first(), permissions, updatedAt);
}

function createShape(e) {
  if(e) {
    buildShape(e, function(shape) {
      whiteboardDelegate.shapeData.shape = shape;
      initShapeEvents(whiteboardDelegate.shapeData.shape, {can_edit: true});
      if(whiteboardDelegate.shapeData.shape) {
        whiteboardDelegate.shapeData.shape.on('drawstop', whiteboardDelegate.deps.Events.shapeWasCreated);
      }
    });
  }
}

function createShapeWithDefaultCoords() {
  buildShape(null, function(shape) {
    whiteboardDelegate.shapeData.shape = shape;
    initShapeEvents(whiteboardDelegate.shapeData.shape, {can_edit: true});
    if(whiteboardDelegate.shapeData.shape) {
      whiteboardDelegate.shapeData.shape.on('drawstop', whiteboardDelegate.deps.Events.shapeWasCreated);
      initShapeEvents(whiteboardDelegate.shapeData.shape);
      whiteboardDelegate.shapeData.shape.draw('stop');
    }
  });

}


function initShapeEvents(shape, permissions, updatedAt) {
  shape.updatedAt = updatedAt;
  shape.permissions = permissions;
  whiteboardDelegate.shapeData.added[shape.id()] = shape;
  if (permissions && permissions.can_edit) {
    shape.off();
    shape.mousedown(selectShape);
    shape.touchstart(selectShape);
    shape.off('resizestart');
    shape.off('resizedone');
    shape.off('dragstart');
    shape.off('dragend');

    shape.on('resizestart', whiteboardDelegate.deps.Events.shapeWillUpdate);
    shape.on('resizedone', whiteboardDelegate.deps.Events.shapeWasUpdated);
    shape.on('dragstart', whiteboardDelegate.deps.Events.shapeWillUpdate);
    shape.on('dragend', whiteboardDelegate.deps.Events.shapeWasUpdated);
  }
}

function buildShape(e, callback) {
  var element = whiteboardDelegate.deps.Elements.shapes[whiteboardDelegate.drawData.current];
  if(element) {
    var nested = whiteboardDelegate.mainGroup.nested();
    var attrs = { fill: whiteboardDelegate.drawData.color, 'stroke-width': whiteboardDelegate.drawData.strokeWidth, stroke: whiteboardDelegate.drawData.color };
    element(e, nested, attrs, function(build) {
      if (!e) {
        build.center(whiteboardDelegate.drawData.initialWidth/2, whiteboardDelegate.drawData.initialHeight/2);
      }
      attrs.id = nested.id() + build.type + Date.now();
      callback(build.attr(attrs));
    });
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
