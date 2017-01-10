module.exports = {
  init,
  last,
  add,
  remove,
  undo,
  redo
};

var whiteboardDelegate;
function init(data) {
  whiteboardDelegate = data;
  whiteboardDelegate.historyData = { undo: [], redo: [] };
  return this;
}

function last(type) {
  return whiteboardDelegate.historyData[type][whiteboardDelegate.historyData[type].length - 1]
}

function add(object, type, when) {
  if(type == 'update' && when == 'end') {
    var historyObject = last('undo');
    historyObject.endElement = object.svg();
  }
  else {
    if(type == 'removeAll') {
      var elements = [];
      for(var id in object) {
        elements.push(_paramsFormat(object[id], 'remove'));
      }
      whiteboardDelegate.historyData.undo.push({ type, elements });
    }
    else {
      whiteboardDelegate.historyData.undo.push(_paramsFormat(object, type));
    }
    whiteboardDelegate.historyData.redo = [];
  }
}

function remove(type) {
  return whiteboardDelegate.historyData[type].pop();
}

function undo() {
  if(whiteboardDelegate.historyData.undo.length) {
    var object = remove('undo');
    whiteboardDelegate.deps.Shape.deselectShape();
    whiteboardDelegate.historyData.redo.push(object);
    _actionUndo(object);
  }
}

function redo() {
  if(whiteboardDelegate.historyData.redo.length) {
    var object = remove('redo');
    whiteboardDelegate.deps.Shape.deselectShape();
    whiteboardDelegate.historyData.undo.push(object);
    _actionRedo(object);
  }
}

function _actionUndo(object) {
  switch(object.type) {
    case 'draw':
      whiteboardDelegate.deps.Actions.undoShapeDelete(object);
      break;
    case 'remove':
      whiteboardDelegate.deps.Shape.loadOne(object.element);
      whiteboardDelegate.deps.Actions.shapeCreate(object);
      break;
    case 'removeAll':
      object.elements.map(_actionUndo);
      break;
    case 'update':
      _update({ id: object.id, element: object.element, type: object.type });
      break;
    default:
      console.error("History undo action not found:", object.type);
  }
}

function _actionRedo(object) {
  switch(object.type) {
    case 'draw':
      whiteboardDelegate.deps.Shape.loadOne(object.element);
      whiteboardDelegate.deps.Actions.shapeCreate(object);
      break;
    case 'remove':
      var shape = SVG.get(object.id);
      whiteboardDelegate.deps.Actions.shapeDelete(shape);
      break;
    case 'removeAll':
      whiteboardDelegate.deps.Actions.shapeDeleteAll();
      break;
    case 'update':
      _update({ id: object.id, element: object.endElement, type: object.type });
      break;
    default:
      console.error("History redo action not found:", object.type);
  }
}

function _update(object) {
  whiteboardDelegate.deps.Actions.shapeUpdate(object);
}

function _paramsFormat(object, type) {
  var params = whiteboardDelegate.deps.Helpers.shapeParams(object);
  return { ...params, type };
}

//           undo  |  redo
// resize = update | update
// move   = update | update
// draw   = remove | draw
// remove = draw   | remove
