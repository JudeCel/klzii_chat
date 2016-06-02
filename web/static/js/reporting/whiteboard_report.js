function draw(class_name, element) {
  var wb = Snap(class_name);

  var svg_el = wb[element.type](element.x1, element.y1, element.x2, element.y2);
  svg_el.attr({
    fill: element.fill,
    stroke: element.stroke,
    style: element.style
  });

  svg_el.transform(element.transform);
}
