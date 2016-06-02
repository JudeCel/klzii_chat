let undoHistory = [];
let undoHistoryIdx = 0;
let historyOwner = "";

function copyObject(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function addStepToUndoHistory(json) {
  //if made a few undo steps, then delete next redo steps first
  if (undoHistoryIdx > 0 && undoHistoryIdx < undoHistory.length - 1) {
    undoHistory = undoHistory.slice(0, undoHistoryIdx + 1);
  }
  undoHistory.push(copyObject(json));
  undoHistoryIdx = undoHistory.length - 1;
}

function addAllDeletedObjectsToHistory(shapes) {
  let objects = [];
  Object.keys(shapes).forEach(function(key, index) {
    let element = shapes[key];
    if (element) {
      objects.push(prepareMessage(element, "delete"));
    }
  });
  addStepToUndoHistory(objects);
}

function processHistory(json, shapes){
  if (json.eventType == "deleteAll") {
    this.addAllDeletedObjectsToHistory(shapes);
  } else {
    this.addStepToUndoHistory(json);
  }
}

function currentStepObject() {
  return undoHistory[undoHistoryIdx];
}
function undoStepObject() {
  undoHistoryIdx--;
  if (undoHistoryIdx < 0) {
    undoHistoryIdx = 0;
    return null;
  } else {
    return undoHistory[undoHistoryIdx];
  }
}

function redoStepObject() {
  undoHistoryIdx++;
  if (undoHistoryIdx > undoHistory.length - 1) {
    undoHistoryIdx = undoHistory.length - 1;
    return null;
  } else {
    return undoHistory[undoHistoryIdx];
  }
}

function getActionCount() {
  return undoHistory.length;
}

function prepareMessage(shape, action, mainAction) {
  var	message = {
    id: shape.id,
    action: (mainAction || "draw"),
    creator: historyOwner
  };

  message.element = shape;
  return {
    eventType: action,
    message: message
  }
}

function setHistoryOwner(userId) {
  historyOwner = userId;
}

module.exports = {
  redoStepObject: redoStepObject,
  undoStepObject: undoStepObject,
  processHistory: processHistory,
  addAllDeletedObjectsToHistory: addAllDeletedObjectsToHistory,
  addStepToUndoHistory: addStepToUndoHistory,
  getActionCount: getActionCount,
  prepareMessage: prepareMessage,
  setHistoryOwner: setHistoryOwner,
  currentStepObject: currentStepObject
};
