import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';

const WhiteboardCanvas = React.createClass({
  componentDidMount() {
    let s = Snap("#" + this.getName());
    var activeShape, lastShape;
    var self = this;

    var Mode = {
      none: "none",
      rectangle: "rectangle",
      circle: "circle",
      scribble: "scribble",
      scribbleFill: "scribbleFill",
      line: "line",
      arrow: "arrow",
      text: "text",
      image: "image",
      erase: "erase"
    };

    this.mode = Mode.none;
    var activeFillColour, activeStrokeWidth, activeStrokeColour;

    function unselectLastShape() {
      if (lastShape) {
        lastShape.ftUnselect();
        lastShape = null;
      }
    }

    function init1() {

      var box = document.getElementById(self.getName());

      box.onMouseDown = function(e) {
        console.log("__mouse down");
        var coords = eventCoords(e || event);
        function eventCoords(e) {
          return {x: e.clientX, y: e.clientY};
        }

        var strokeColour = activeStrokeColour;
        var fillColour = activeFillColour;
        var fillNone = 'none';

        function moveDistance(dx, dy) {
          return Math.sqrt( Math.pow( dx, 2)  + Math.pow( dy, 2)  );
        }

        box.onmousemove1 = function(e) {
          var coordsMove = eventCoords(e || event);
          var dx = coordsMove.x - coords.x;
          var dy = coordsMove.y - coords.y;

          if(!activeShape && moveDistance(dx, dy) > 5) {

            unselectLastShape();

            if (self.mode == Mode.scribble) {
              activeShape = s.polyline([]).transform('r0.1');
              self.setStyle(activeShape, fillNone, 4, strokeColour);
            }

            if (self.mode == Mode.scribbleFill) {
              activeShape = s.polyline([]).transform('r0.1');
              self.setStyle(activeShape, fillColour, 4, strokeColour);
            }

            if (self.mode == Mode.rectangle) {
              s.rect(30, 130, 90, 3, 5, 5).attr({fill: '#ccc', opacity: 0.2});
              console.log("_____", s);
              activeShape = s.rect(coords.x, coords.y, 10, 10).transform('r0.1');
              self.setStyle(activeShape, fillColour, 4, strokeColour);
            }

            if (self.mode == Mode.circle) {
              activeShape = s.ellipse(coords.x-2, coords.y-2, 4, 4).transform('r0.1');
              self.setStyle(activeShape, fillColour, 4, strokeColour);
            }

            if (self.mode == Mode.line) {
              activeShape = s.line(coords.x, coords.y, coords.x + 1, coords.y + 1).transform('r0.1');
              self.setStyle(activeShape, fillColour, 4, strokeColour);
            }

            if (self.mode == Mode.arrow) {
              var arrow = s.polygon([0,10, 4,10, 2,0, 0,10]).attr({fill: fillColour}).transform('r270');
              var marker = arrow.marker(0,0, 10,10, 0,5);
              activeShape = s.line(coords.x, coords.y, coords.x + 1, coords.y + 1).attr({markerStart: marker}).transform('r0.1');
              self.setStyle(activeShape, fillColour, 4, strokeColour);
            }

            if (activeShape) {
              activeShape.ftInitShape();
            }
          }

          if (activeShape && !activeShape.created) {
            if (activeShape.type == "polyline") {
              var points = activeShape.attr('points')||[];
              points.push(coordsMove.x, coordsMove.y);
              activeShape.attr('points', points);
            }

            if (activeShape.type == "rect") {
              var x = coords.x;
              var y = coords.y;
              if (dx < 0) {
                x += dx;
                dx *= -1;
              }
              if (dy < 0) {
                y += dy;
                dy *= -1;
              }
              var size = {x: x, y: y, width: dx, height: dy};
              activeShape.attr(size);
            }

            if (activeShape.type == "ellipse") {
              var x = coords.x;
              var y = coords.y;
              if (dx < 0) {
                dx *= -1;
              }
              if (dy < 0) {
                dy *= -1;
              }
              var size = {rx: dx, ry: dy};
              activeShape.attr(size);
            }

            if (activeShape.type == "line") {
              activeShape.attr({x1: coordsMove.x, y1: coordsMove.y});
            }

            activeShape.ftHighlightBB();
          }
        }

        box.onmouseup1 = function() {
          if (activeShape && !activeShape.created) {
            activeShape.created = true;
            self.prepareNewElement(activeShape);
            self.addInputControl(activeShape);
            lastShape = activeShape;
          }
          activeShape = null;
          box.onmousemove = null;
        }

      }
    }

    init1();

    this.addRect = function(fill) {
      this.mode = Mode.rectangle;
      activeStrokeColour = 'red';
      if (fill) {
        activeFillColour = 'red';
      } else {
        activeFillColour = "none";
      }
    };

    this.addCircle = function(fill) {
      this.mode = Mode.circle;
      activeStrokeColour = 'red';
      if (fill) {
        activeFillColour = 'red';
      } else {
        activeFillColour = "none";
      }
    };

    this.addText = function(text) {
      this.mode = Mode.text;
      var r = s.text(10, 50, text);
      this.setStyle(r);
      this.prepareNewElement(r);
    };

    this.addLine = function(arrow) {
      if (arrow) {
        this.mode = Mode.arrow;
      } else {
        this.mode = Mode.line;
      }
    }

    this.addImage = function(url, coords) {
      this.mode = Mode.image;
      var r = s.image(url ,coords.x, coords.y, coords.width, coords.height).transform('r0.1');
      this.setStyle(r);
      this.prepareNewElement(r);
    }

    this.addScribble = function(full) {
      if (full) {
        this.mode = Mode.scribbleFill;
        activeFillColour = 'red';
      } else {
        activeFillColour = "none";
        this.mode = Mode.scribble;
      }
      activeStrokeColour = 'red';
    }

    this.prepareNewElement = function(el) {
      el.ftSetSelectedCallback(this.shapeSelected);
      //this.addInputControl(el);
    }

    this.setStyle = function(el, colour, strokeWidth, strokeColour) {
      el.attr({'fill': colour, stroke: strokeColour, strokeWidth: strokeWidth});
    }

    this.addInputControl = function(el) {
      el.ftCreateHandles();
    }

    this.shapeSelected = function(el, selected) {
      if (selected) {
    //    unselectLastShape();
        if (activeShape && activeShape != el) {
          activeShape.ftUnselect();
          activeShape = null;
        }

        if (el) {
          lastShape = el;
          activeShape = el;
        }
      } else {
        activeShape = null;
      }
    }

    this.deleteActive = function() {
      if (activeShape) {
        activeShape.ftRemove();
        activeShape = null;
      }
    }

    activeShape = s.ellipse(200, 200, 150, 100).transform('r0.1');
    self.setStyle(activeShape, 'red', 4, 'green');
  },
  getName() {
    return 'Whiteboard_';
  },
  shouldComponentUpdate(nextProps) {
    return false;
  },
  componentDidUpdate() {
    let s = Snap(getName());
    this.componentDidMount();
  },
  handleMouseDown: function(event){
    console.log("mouse ");
  },
  handleMouseMove(e) {
    console.log("move", e);
  },
  render() {
    return (
        <div   width='950px' height="460px" onMouseDown={ this.handleMouseDown } onMouseMove={ this.handleMouseMove }><svg id={ this.getName() } width='950px' height="460px"/></div>
    )
  }
});

export default WhiteboardCanvas;
