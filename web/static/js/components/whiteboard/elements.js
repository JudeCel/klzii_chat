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

function circleEmpty(e, nested, attrs) {
  attrs.fill = 'none';
  return circleFilled(e, nested, attrs);
}

function circleFilled(e, nested, attrs) {
  return nested.ellipse().draw(e);
}

function rectEmpty(e, nested, attrs) {
  attrs.fill = 'none';
  return rectFilled(e, nested, attrs);
}

function rectFilled(e, nested, attrs) {
  return nested.rect().draw(e);
}

function scribbleEmpty(e, nested, attrs) {
  attrs.fill = 'none';
  return scribbleFilled(e, nested, attrs);
}

function scribbleFilled(e, nested, attrs) {
  attrs['pointer-events'] = 'all';
  whiteboardDelegate.deps.Shape.setMouseType('stop');
  var build = nested.polyline().draw(e);
  build.remember('_paintHandler').drawCircles = function() {};
  return build;
}

function line(e, nested, attrs) {
  return nested.line(0, 0, 0, 0).draw(e);
}

function arrow(e, nested, attrs) {
  attrs['marker-end'] = whiteboardDelegate.markers.arrows[whiteboardDelegate.props.currentUser.id];
  return nested.line(0, 0, 0, 0).draw(e);
}

function image(e, nested, attrs) {
  attrs.fill = 'none';
  return nested.image(whiteboardDelegate.drawData.imageUrl).draw(e);
}

function text(e, nested, attrs) {
  attrs['font-size'] = 25;
  return nested.plain(whiteboardDelegate.drawData.text).draw(e);
}
