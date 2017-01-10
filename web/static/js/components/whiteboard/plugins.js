SVG.Element.prototype.draw.extend({
  'text': {
    init: function(e){
      this.startPoint.x = e.clientX;
      this.startPoint.y = e.clientY;
      this.el.attr({ x: this.startPoint.x, y: this.startPoint.y, 'font-size': 24 });
    },
    calc: function (e) {
      var text = {
        x: this.startPoint.x,
        y: this.startPoint.y
      },  point = this.transformPoint(e.clientX, e.clientY);

      text.width = point.x - text.x;
      text.height = point.y - text.y;
      this.snapToGrid(1);

      //When no width/height is present - means that the element hasn't appeared on screen yet
      if(text.width < 1) {
        text.x = text.x - this.el.node.clientWidth/2;
        text.width = this.el.node.clientWidth;
      }

      // ...same with height
      if (text.height < 1) {
        text.height = this.el.node.clientHeight;
      }
      this.el.attr(text);
    }
  }
});
