import whiteboardUtilities  from './whiteboardUtilities';
let undoHistory = [];
let currentIdx = 0;

function addStepToUndoHistory(json) {
  if (!whiteboardUtilities.areObjectsEqual(json, currentStepObject())) {
    //if made a few undo steps, then delete next redo steps first
    if (currentIdx > 0 && currentIdx < undoHistory.length - 1) {
      undoHistory = undoHistory.slice(0, currentIdx + 1);
    }
    undoHistory.push(whiteboardUtilities.copyObject(json));
    currentIdx = undoHistory.length - 1;
  }
}

function currentStepObject() {
  return undoHistory[currentIdx];
}
function undoStepObject() {
  let currentObject = undoHistory[currentIdx];
  if (currentObject) {
      currentIdx--;
  }
  return currentObject;
}

function redoStepObject() {
  let currentObject = undoHistory[currentIdx + 1];
  if (currentObject) {
      currentIdx++;
  }
  return currentObject;
}

function getActionCount() {
  return undoHistory.length;
}

module.exports = {
  redoStepObject: redoStepObject,
  undoStepObject: undoStepObject,
  addStepToUndoHistory: addStepToUndoHistory,
  getActionCount: getActionCount,
  currentStepObject: currentStepObject
};
