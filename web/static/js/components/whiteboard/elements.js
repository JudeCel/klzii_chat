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

function image(e, nested, attrs, callback) {
  attrs.fill = 'none';
  
  let image = nested.image(whiteboardDelegate.drawData.imageUrl);
  image.loaded(function(loader) {
    this.size(loader.width, loader.height);
    callback(image);
  });
}

function text(e, nested, attrs, callback) {
  attrs['font-size'] = 25;
  callback(nested.plain(whiteboardDelegate.drawData.text).draw(e));
}
