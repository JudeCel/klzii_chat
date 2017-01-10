module.exports = {
  init,
  last,
  add,
  remove,
  undo,
  redo
};

var self;
function init(data) {
  self = data;
  self.historyData = { undo: [], redo: [] };
  return this;
}

function last(type) {
  return self.historyData[type][self.historyData[type].length - 1]
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
      self.historyData.undo.push({ type, elements });
    }
    else {
      self.historyData.undo.push(_paramsFormat(object, type));
    }
    self.historyData.redo = [];
  }
}

function remove(type) {
  return self.historyData[type].pop();
}

function undo() {
  if(self.historyData.undo.length) {
    var object = remove('undo');
    self.deps.Shape.deselectShape();
    self.historyData.redo.push(object);
    _actionUndo(object);
  }
}

function redo() {
  if(self.historyData.redo.length) {
    var object = remove('redo');
    self.deps.Shape.deselectShape();
    self.historyData.undo.push(object);
    _actionRedo(object);
  }
}

function _actionUndo(object) {
  switch(object.type) {
    case 'draw':
      var shape = SVG.get(object.id);
      self.deps.Actions.shapeDelete(shape);
      break;
    case 'remove':
      self.deps.Shape.loadOne(object.element);
      self.deps.Actions.shapeCreate(object);
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
      self.deps.Shape.loadOne(object.element);
      self.deps.Actions.shapeCreate(object);
      break;
    case 'remove':
      var shape = SVG.get(object.id);
      self.deps.Actions.shapeDelete(shape);
      break;
    case 'removeAll':
      self.deps.Actions.shapeDeleteAll();
      break;
    case 'update':
      _update({ id: object.id, element: object.endElement, type: object.type });
      break;
    default:
      console.error("History redo action not found:", object.type);
  }
}

function _update(object) {
  self.deps.Actions.shapeUpdate(object);
}

function _paramsFormat(object, type) {
  var params = self.deps.Helpers.shapeParams(object);
  return { ...params, type };
}

//           undo  |  redo
// resize = update | update
// move   = update | update
// draw   = remove | draw
// remove = draw   | remove
