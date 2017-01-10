SVG.Element.prototype.draw.extend({
  'text': {
    init:function(e){
      this.startPoint.x = e.clientX;
      this.startPoint.y = e.clientY;
      var point = this.startPoint;

      this.el.attr({ x: point.x, y: point.y, 'font-size': 24 });
    },
    calc: function (e) {
      var text = {
        x: this.startPoint.x,
        y: this.startPoint.y
      },  point = this.transformPoint(e.clientX, e.clientY);

      text.width = point.x - text.x;
      text.height = point.y - text.y;
      this.snapToGrid(1);

      // When width is less than one, we have to draw to the left
      // which means we have to move the start-point to the left
      if(text.width < 1) {
        text.x = text.x + text.width/2;
        text.width = -text.width;
      }

      // ...same with height
      if (text.height < 1) {
        text.y = text.y + text.height;
        text.height = -text.height;
      }
      this.el.attr(text);
    }
  }
});
