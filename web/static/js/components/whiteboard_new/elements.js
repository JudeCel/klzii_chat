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
  build.remember('_paintHandler').drawCircles = function() {};
  return build;
}

function line(e, nested, attrs) {
  return nested.line(0, 0, 0, 0).draw(e);
}

function arrow(e, nested, attrs) {
  attrs['marker-end'] = self.markers.arrows[self.props.currentUser.id];
  return nested.line(0, 0, 0, 0).draw(e);
}

function image(e, nested, attrs) {
  attrs.fill = 'none';
  return nested.image(self.drawData.imageUrl).draw(e);
}

function text(e, nested, attrs) {
  return nested.plain(self.drawData.text).draw(e);
}
