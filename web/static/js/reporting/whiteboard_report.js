var arrows =  [];
var wb;

var drawElements = function (element_id, shapes) {
  wb = SVG(element_id);
  let boxSize = "0 0 925 465";
  wb.attr({viewBox: boxSize, preserveAspectRatio: "xMidYMid meet" });

  shapes.forEach(function(shape) {
    createArrowTip(shape.sessionMemberId, shape.colour);
    draw(wb, shape.event.type, shape.event.element)
  });
}

function createArrowTip(id, colour) {
  if (!arrows[id]) {
    let marker = wb.defs().marker(10, 10).attr({ id: 'marker-arrow-' + id, fill: colour, 'stroke': 'none', orient: 'auto', 'viewBox': "0 0 10 10" , strokeWidth: '0 !important'} );
    marker.path('M 0 0 L 10 5 L 0 10 z');
    arrows[id] = marker;
  }
};

var draw = function (wb, type, element) {
  wb.svg(element);
}

if ('undefined' !== typeof module) {
  module.exports = {drawElements: drawElements};
}
