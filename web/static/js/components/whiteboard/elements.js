module.exports = {
  init,
  shapes: {
    circleEmpty,
    circleFilled,
    rectEmpty,
    rectFilled,
    scribbleEmpty,
    scribbleFilled,
    line,
    arrow,
    image,
    text,
  }
};

var whiteboardDelegate;
function init(data) {
  whiteboardDelegate = data;
  return this;
}

function circleEmpty(e, nested, attrs, callback) {
  attrs.fill = 'none';
  callback(circleFilled(e, nested, attrs));
}

function circleFilled(e, nested, attrs, callback) {
  callback(nested.ellipse().draw(e));
}

function rectEmpty(e, nested, attrs, callback) {
  attrs.fill = 'none';
  rectFilled(e, nested, attrs, callback);
}

function rectFilled(e, nested, attrs, callback) {
  callback(nested.rect().draw(e));
}

function scribbleEmpty(e, nested, attrs, callback) {
  attrs.fill = 'none';
  scribbleFilled(e, nested, attrs, callback);
}

function scribbleFilled(e, nested, attrs, callback) {
  attrs['pointer-events'] = 'all';
  whiteboardDelegate.deps.Shape.setMouseType('stop');
  var build = nested.polyline().draw(e);
  build.remember('_paintHandler').drawCircles = function() {};
  callback(build);
}

function line(e, nested, attrs, callback) {
  callback(nested.line(0, 0, 0, 0).draw(e));
}

function arrow(e, nested, attrs, callback) {
  attrs['marker-end'] = whiteboardDelegate.markers.arrows[whiteboardDelegate.props.currentUser.id];
  callback(nested.line(0, 0, 0, 0).draw(e));
}

function adjustImageSize(loadedImageInfo) {
  let scale = 1;
  //restrict image size to whiteboard screen size (Max it's height)
  if (loadedImageInfo.width >= whiteboardDelegate.drawData.initialHeight) {
    scale = whiteboardDelegate.drawData.initialHeight/loadedImageInfo.width;
  } else if (loadedImageInfo.height >= whiteboardDelegate.drawData.initialHeight) {
    scale = whiteboardDelegate.drawData.initialHeight/loadedImageInfo.height;
  }
  loadedImageInfo.width *= scale;
  loadedImageInfo.height *= scale;
}

function image(e, nested, attrs, callback) {
  attrs.fill = 'none';
  let image = nested.image(whiteboardDelegate.drawData.imageUrl);
  image.loaded(function(loadedImageInfo) {
    adjustImageSize(loadedImageInfo);
    this.size(loadedImageInfo.width, loadedImageInfo.height);
    callback(image);
  });
}

function text(e, nested, attrs, callback) {
  attrs['font-size'] = 25;
  callback(nested.plain(whiteboardDelegate.drawData.text).draw(e));
}
