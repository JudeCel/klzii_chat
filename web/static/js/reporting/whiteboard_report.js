function draw(class_name, type, attr, image_path) {
  var wb = Snap('.' + class_name);
  var svg_el;

  switch(type){
    case "ellipse":
      svg_el = wb.ellipse(attr.cx, attr.cy, attr.rx, attr.ry);
      break;
    case "rect":
      svg_el = wb.rect(attr.x, attr.y, attr.width, attr.height);
      break;
    case "polyline":
      svg_el = wb.polyline(attr.points.split(','));
      break;
    case "line":
      svg_el = wb.line(attr.x1, attr.y1, attr.x2, attr.y2);
      break;
    case "text":
      svg_el = wb.text(attr.x, attr.y, attr.textVal);
      break;
    case "image":
      svg_el = wb.image(image_path + '/' + attr.href, attr.x, attr.y, attr.width, attr.height);  //TODO: correct full path to images upload folder
      break;
    default:
      return;
  }

  if(type != "image") {
    svg_el.attr({
      fill: attr.fill != "undefined" ? attr.fill : undefined,
      stroke: attr.stroke != "undefined" ? attr.stroke : undefined,
      style: attr.style != "undefined" ? attr.style : undefined
    });
  }

  svg_el.transform(attr.transform);
}