function copyObject(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function areObjectsEqual(objectA, objectB) {
  if (!objectA || !objectB) {
    return false;
  }
  let objA = JSON.parse(JSON.stringify(objectA));
  let objB = JSON.parse(JSON.stringify(objectB));

  let key;
  for(key in objB) {
    if(typeof(objA[key])=='undefined') {return false;}
  }

  for(key in objB) {
    if (objB[key]) {
      switch(typeof(objB[key])) {
        case 'object':
          if (!areObjectsEqual(objB[key], objA[key])) { return false; } break;
        default:
          if (objB[key] != objA[key]) { return false; }
      }
    } else {
      if (objA[key])
        return false;
    }
  }
  return true;
}

module.exports = {
  copyObject: copyObject,
  areObjectsEqual: areObjectsEqual
}
