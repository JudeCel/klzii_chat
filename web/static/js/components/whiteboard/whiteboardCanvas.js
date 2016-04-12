import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';
var ResizableBox = require('react-resizable').ResizableBox;

require("./drawControlls");

const WhiteboardCanvas = React.createClass({
  unselectLastShape() {
    if (this.lastShape) {
      this.lastShape.ftUnselect();
      this.lastShape = null;
    }
  },
  moveDistance(dx, dy) {
    return Math.sqrt( Math.pow( dx, 2)  + Math.pow( dy, 2)  );
  },
  componentDidMount() {
    //this.minimized = false;
    this.snap = Snap("#" + this.getName());
    this.activeShape = null;
    this.lastShape = null;
    var self = this;

    this.ModeEnum = {
      none: 0,
      rectangle: 1,
      circle: 2,
      scribble: 3,
      scribbleFill: 4,
      line: 5,
      arrow: 6,
      text: 7,
      image: 8,
      erase: 9
    };

    this.mode = this.ModeEnum.none;
    var activeFillColour, activeStrokeWidth, activeStrokeColour;

    this.addRect = function(fill) {
      this.mode = this.ModeEnum.rectangle;
      this.activeStrokeColour = 'red';
      if (fill) {
        this.activeFillColour = 'red';
      } else {
        this.activeFillColour = "none";
      }
    };

    this.addCircle = function(fill) {
      this.mode = this.ModeEnum.circle;
      this.activeStrokeColour = 'red';
      if (fill) {
        this.activeFillColour = 'red';
      } else {
        this.activeFillColour = "none";
      }
    };

    this.addText = function(text) {
      this.mode = this.ModeEnum.text;
      var r = this.snap.text(10, 50, text);
      this.setStyle(r);
      this.prepareNewElement(r);
    };

    this.addLine = function(arrow) {
      if (arrow) {
        this.mode = this.ModeEnum.arrow;
      } else {
        this.mode = this.ModeEnum.line;
      }
    }

    this.addImage = function(url, coords) {
      this.mode = this.ModeEnum.image;
      var r = this.snap.image(url ,coords.x, coords.y, coords.width, coords.height).transform('r0.1');
      this.setStyle(r);
      this.prepareNewElement(r);
    }

    this.addScribble = function(full) {
      if (full) {
        this.mode = this.ModeEnum.scribbleFill;
        this.activeFillColour = 'red';
      } else {
        this.activeFillColour = "none";
        this.mode = this.ModeEnum.scribble;
      }
      this.activeStrokeColour = 'red';
    }

    this.prepareNewElement = function(el) {
      el.ftSetSelectedCallback(this.shapeSelected);
      //this.addInputControl(el);
    }



    this.addInputControl = function(el) {
      el.ftCreateHandles();
    }

  },
  setStyle(el, colour, strokeWidth, strokeColour) {
    el.attr({'fill': colour, stroke: strokeColour, strokeWidth: strokeWidth});
  },
  shapeSelected(el, selected) {
    if (selected) {
      if (this.activeShape && this.activeShape != el) {
        this.activeShape.ftUnselect();
        this.activeShape = null;
      }

      if (el) {
        this.lastShape = el;
        this.activeShape = el;
      }
    } else {
      this.activeShape = null;
    }
  },
  deleteActive() {
    if (this.activeShape) {
      this.activeShape.ftRemove();
      this.activeShape = null;
    }
  },
  getName() {
    return 'Whiteboard_';
  },
  shouldComponentUpdate(nextProps) {
    return false;
  },
  componentDidUpdate() {
    let s = Snap(this.getName());
    this.componentDidMount();
  },
  eventCoords(e) {
    var bounds = e.target.getBoundingClientRect();
    return({x: Number(e.clientX) - Number(bounds.left), y: Number(e.clientY) - Number(bounds.top)});
  },
  handleMouseDown: function(e){
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;
    this.addCircle(true);
    this.coords = this.eventCoords(e);
    this.strokeColour = this.activeStrokeColour;
    this.fillColour = this.activeFillColour;
    this.fillNone = 'none';
  },
  handleMouseUp: function(e){
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;
    if (this.activeShape && !this.activeShape.created) {
      this.activeShape.created = true;
      this.prepareNewElement(this.activeShape);
      this.addInputControl(this.activeShape);
      this.lastShape = this.activeShape;
    }
    this.coords = null;
    this.activeShape = null;
  },
  handleMouseMove(e) {
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;

    if (!this.coords) return;


    var coordsMove = this.eventCoords(e);
    var dx = coordsMove.x - this.coords.x;
    var dy = coordsMove.y - this.coords.y;

    if(!this.activeShape && this.moveDistance(dx, dy) > 5) {
      this.unselectLastShape();

      if (this.mode == this.ModeEnum.scribble) {
        this.activeShape = this.snap.polyline([]).transform('r0.1');
        this.setStyle(this.activeShape, this.fillNone, 4, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.scribbleFill) {
        this.activeShape = this.snap.polyline([]).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, 4, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.rectangle) {
        this.activeShape = this.snap.rect(this.coords.x, this.coords.y, 10, 10).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, 4, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.circle) {
        this.activeShape = this.snap.ellipse(this.coords.x-2, this.coords.y-2, 4, 4).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, 4, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.line) {
        this.activeShape = this.snap.line(this.coords.x, this.coords.y, this.coords.x + 1, this.coords.y + 1).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, 4, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.arrow) {
        var arrow = this.snap.polygon([0,10, 4,10, 2,0, 0,10]).attr({fill: this.fillColour}).transform('r270');
        var marker = arrow.marker(0,0, 10,10, 0,5);
        this.activeShape = this.snap.line(this.coords.x, this.coords.y, this.coords.x + 1, this.coords.y + 1).attr({markerStart: marker}).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, 4, this.strokeColour);
      }

      if (this.activeShape) {
        this.activeShape.ftInitShape();
      }
    }

    if (this.activeShape && !this.activeShape.created) {
      if (this.activeShape.type == "polyline") {
        var points = this.activeShape.attr('points')||[];
        points.push(coordsMove.x, coordsMove.y);
        this.activeShape.attr('points', points);
      }

      if (this.activeShape.type == "rect") {
        var x = this.coords.x;
        var y = this.coords.y;
        if (dx < 0) {
          x += dx;
          dx *= -1;
        }
        if (dy < 0) {
          y += dy;
          dy *= -1;
        }
        var size = {x: x, y: y, width: dx, height: dy};
        this.activeShape.attr(size);
      }

      if (this.activeShape.type == "ellipse") {
        var x = this.coords.x;
        var y = this.coords.y;
        if (dx < 0) {
          dx *= -1;
        }
        if (dy < 0) {
          dy *= -1;
        }
        var size = {rx: dx, ry: dy};
        this.activeShape.attr(size);
      }

      if (this.activeShape.type == "line") {
        this.activeShape.attr({x1: coordsMove.x, y1: coordsMove.y});
      }

      this.activeShape.ftHighlightBB();
    }
  },
  isValidButton(e) {
    return (e && e.button == 0);
  },
  expand() {
    this.minimized = !this.isMinimized();
    //console.log("______", this.minimized);
    this.setState({minimized: this.minimized});
  },
  getWidth() {
    if (this.minimized) {
      return 316;
    } else {
      return 950;
    }
  },
  getHeight() {
    if (this.minimized) {
      return 153;
    } else {
      return 460;
    }
  },
  getMinimizedScale() {
    return 153/316;
  },
  isMinimized() {
    return this.minimized;
  },
  shouldComponentUpdate: function () {
    return true;
  },
  update: function () {
    this.setState({});
  },

  render() {
    var divStyle = {
      WebkitTransition: 'all', // note the capital 'W' here
      msTransition: 'all', // 'ms' is the only lowercase vendor prefix
      width: this.getWidth()+'px',
      height: this.getHeight()+'px',
      'WebkitTransition': 'width 0.5s ease-in-out, height 0.5s ease-in-out',
      'MozTransition': 'width 0.5s ease-in-out, height 0.5s ease-in-out',
      'OTransition': 'width 0.5s ease-in-out, height 0.5s ease-in-out',
      transition: 'width 0.5s ease-in-out, height 0.5s ease-in-out'
    };
    var scale = this.minimized?this.getMinimizedScale():1.0;
    var scaleSVGStyle = {
      transform: 'scale('+scale+')',
      transition: 'transform 0.5s ease-in-out',
      left: 0,
      top: 0
    }
    // return (
    //   <div style={divStyle}>
    //     <div onClick={ this.expand }> expand</div>
    //     <svg id={ this.getName() } width='100%' height="100%" style={scaleSVGStyle} onMouseDown={ this.handleMouseDown } onMouseUp={ this.handleMouseUp } onMouseMove={ this.handleMouseMove }/>
    //   </div>
    // )

    return (
      <div style={divStyle}>
        <div onClick={ this.expand }> expand</div>
        <div id="title-whiteboard"
          style={{
            background: "black",
            zIndex: 1,
            position: "absolute",
            left: "368px",
            top: "82px",
            width: "85px",
            height: "30px",
            argin: 0
          }}>
          title
        </div>
        <div onClick={ this.expand } id="expand"
          style={{
            zIndex: 1,
            background: "green",
            position: "absolute",
            left: "624px",
            top: "79px",
            width: "36px",
            height: "36px",
            margin: 0
            }}>
        </div>
       <div id="shrink"
         style={{
          background: "yellow",
          zIndex: 3,
          position: "absolute",
          left: "900px",
          top: "62px",
          width: "51px",
          height: "51px",
          margin: "0"
        }}>
       </div>

          <svg id={ this.getName() }
            width='100%' height="100%"
            style={scaleSVGStyle}
            onMouseDown={ this.handleMouseDown }
            onMouseUp={ this.handleMouseUp }
            onMouseMove={ this.handleMouseMove }/>

        <div id="expand"
          onClick={this.expand}
          style={{zIndex: 1,
            background: "gray",
            position: "absolute",
            left: "624px",
            top: "79px",
            width: "36px",
            height: "36px",
            margin: 0
          }}>
        </div>
        <div id="shrink"
          onClick={this.expand}
          style={{
            zIndex: 3,
            background: "purple",
            position: "absolute",
            left: "900px",
            top: "62px",
            width: "51px",
            height: "51px",
            margin: 0
          }}>
        </div>
      </div>
    )
  }
});

export default WhiteboardCanvas;
