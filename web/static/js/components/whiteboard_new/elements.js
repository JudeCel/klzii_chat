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
  }
};

var self;
function init(data) {
  self = data;
  return this;
}

function circleEmpty(e, nested, attrs) {
  attrs.fill = 'none';
  return circleFilled(e, nested, attrs);
}

function circleFilled(e, nested, attrs) {
  return nested.circle().draw(e);
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
  self.deps.Shape.setMouseType('stop');
  var build = nested.polyline().draw(e);
  build.remember("_paintHandler").drawCircles = function() {};
  return build;
}

function line(e, nested, attrs) {
  return nested.line(0, 0, 0, 0).draw(e);
}
