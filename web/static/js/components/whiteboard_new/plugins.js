SVG.Element.prototype.draw.extend('text', {
  init:function(e){
    var p = this.startPoint;
    this.el.attr({ x: p.x, y: p.y, 'font-size': 1 });
  },
  calc:function (e) {
    var text = {
      x: this.startPoint.x,
      y: this.startPoint.y
    },  p = this.transformPoint(e.clientX, e.clientY);

    text.width = p.x - text.x;
    text.height = p.y - text.y;

    // Snap the params to the grid we specified
    this.snapToGrid(text);

    // When width is less than one, we have to draw to the left
    // which means we have to move the start-point to the left
    if(text.width < 1) {
      text.x = text.x + text.width;
      text.width = -text.width;
    }

    // ...same with height
    if (text.height < 1) {
      text.y = text.y + text.height;
      text.height = -text.height;
    }

    var size = (text.width + text.height)/2;
    text['font-size'] = size > 1 ? size : 1;
    // draw the element
    this.el.attr(text);
  }
});
