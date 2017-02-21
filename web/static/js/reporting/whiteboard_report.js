var frames = document.getElementsByClassName('whiteboard-frame');
var scale = (713 / 925 );

for (var i = 0; i < frames.length; i++) {
  frames[i].style.height = (scale * 465) + "px";
}

var arrows =  [];
var wb;
var drawSVGElements = function (element_id, shapes) {
  wb = SVG(element_id);
  var boxSize = "0 0 925 465";
  wb.attr({viewBox: boxSize, preserveAspectRatio: "xMidYMid meet" });

  shapes.forEach(function(shape) {
    createArrowTip(shape.sessionMemberId, shape.colour);
    drawElement(wb, shape.event.type, shape.event.element)
  });
}

function createArrowTip(id, colour) {
  if (!arrows[id]) {
    var marker = wb.defs().marker(10, 10).attr({ id: 'marker-arrow-' + id, fill: colour, 'stroke': 'none', orient: 'auto', 'viewBox': "0 0 10 10" , strokeWidth: '0 !important'} );
    marker.path('M 0 0 L 10 5 L 0 10 z');
    arrows[id] = marker;
  }
}

var drawElement = function (wb, type, element) {
  wb.svg(element);
}

if ('undefined' !== typeof module) {
   module.exports = {drawSVGElements: drawSVGElements};
}
