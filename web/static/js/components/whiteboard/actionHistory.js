let undoHistory = [];
let currentIdx = 0;

function copyObject(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function areObjectsEqual(a, b) {
  if (!a || !b) {
    return false;
  }
  let x = JSON.parse(JSON.stringify(a));
  let y = JSON.parse(JSON.stringify(b));
  let p;
  for(p in y) {
    if(typeof(x[p])=='undefined') {return false;}
  }

  for(p in y) {
    if (y[p]) {
      switch(typeof(y[p])) {
        case 'object':
          if (!areObjectsEqual(y[p], x[p])) { return false; } break;
        default:
          if (y[p] != x[p]) { return false; }
      }
    } else {
      if (x[p])
        return false;
    }
  }
  return true;
}

function addStepToUndoHistory(json) {
  if (!areObjectsEqual(json, currentStepObject())) {
    //if made a few undo steps, then delete next redo steps first
    if (currentIdx > 0 && currentIdx < undoHistory.length - 1) {
      undoHistory = undoHistory.slice(0, currentIdx + 1);
    }
    undoHistory.push(copyObject(json));
    currentIdx = undoHistory.length - 1;
  }
}

function currentStepObject() {
  return undoHistory[currentIdx];
}
function undoStepObject() {
  currentIdx--;
  if (currentIdx < 0) {
    currentIdx = 0;
    return null;
  } else {
    return undoHistory[currentIdx];
  }
}

function redoStepObject() {
  currentIdx++;
  if (currentIdx > undoHistory.length - 1) {
    currentIdx = undoHistory.length - 1;
    return null;
  } else {
    return undoHistory[currentIdx];
  }
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
