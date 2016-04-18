import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';
import { OverlayTrigger, Button, Popover, ButtonToolbar, Input}    from 'react-bootstrap'
import { Modal }          from 'react-bootstrap'
import whiteboardActions    from '../../actions/whiteboard'
import { connect }          from 'react-redux';
require("./drawControlls");

const WhiteboardCanvas = React.createClass({
  getInitialState:function() {
    this.minimized = true;
    this.MIN_WIDTH = 316;
    this.MIN_HEIGHT = 153;
    this.MAX_WIDTH = 950;
    this.MAX_HEIGHT = 460;
    this.WHITEBOARD_BORDER_COLOUR = '#a4918b';
    this.WHITEBOARD_BACKGROUND_COLOUR = '#e1d8d8';
    this.WHITEBOARD_CANVAS_BORDER_COLOUR = '#ffc973';
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
    this.shapes = [];
    this.mode = this.ModeEnum.none;
    return {content: '', addTextDisabled: true, addTextValue: '', needEvents: true};
  },
  initMessaging() {
    window.sendMessage = function (json) {
      switch (json.type) {
        case 'sendobject':
          this.props.member.dispatch(whiteboardActions.sendobject(this.props.channal, json.message));
          break;
        case 'move':
        case 'scale':
        case 'rotate':
          this.props.dispatch(whiteboardActions.updateObject(this.props.channal, json.message));
          break;

        case 'delete':
          this.props.dispatch(whiteboardActions.deleteObject(this.props.channal, json.id));
          break;
        default:

      }
    //	make sure we have enough information
      if (isEmpty(json)) return;
      if (isEmpty(json.type)) return;

      if (json.message) {
        // socket.emit(json.type);					//	don't need to pass any arguments
      } else {
      }
    }.bind(this);
  },
  componentWillReceiveProps(nextProps) {

    if (nextProps.channal && this.state.needEvents) {
      nextProps.dispatch(whiteboardActions.subscribeWhiteboardEvents(nextProps.channal, this));
      nextProps.dispatch(whiteboardActions.getWhiteboardHistory(nextProps.channal, this));
      this.state.needEvents = false;
    }
  },
  processWhiteboard(data) {
    var self = this;
    data.map(function(item) {
        var obj;
        console.log("~~~~==============", item.event.id);
        obj = self.shapes[item.event.id];
        if (!obj) {
          switch (item.event.element.type) {
            case "ellipse":
              obj = self.snap.ellipse(0, 0, 0, 0).transform('r0.1');
              break;
            case "rect":
              obj = self.snap.rect(0, 0, 0, 0).transform('r0.1');
              break;
            case "polyline":
              obj = self.snap.polyline([]).transform('r0.1');
              break;
            case "line":
              obj = self.snap.line(0, 0, 0, 0).transform('r0.1');
              break;
            default:
              break;
          };

          self.prepareNewElement(obj);
          self.addInputControl(obj);
        }

        if (obj) {
          obj.attr(item.event.element.attr);
          obj.created = true;
          self.shapes[item.event.id] = obj;
        }
    });

  },
  shapeTransformed(shape) {
    this.activeShape = shape;
    this.sendObjectData('move');
  },
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
    this.snap = Snap("#" + this.getName());
    this.activeShape = null;
    this.lastShape = null;
    var self = this;
    var activeFillColour, activeStrokeWidth, activeStrokeColour;
    this.initMessaging();
  },
  addRect(fill) {
    this.mode = this.ModeEnum.rectangle;
    this.activeStrokeColour = 'red';
    if (fill) {
      this.activeFillColour = 'red';
    } else {
      this.activeFillColour = "none";
    }
  },
  addRectEmpty() {
    this.addRect();
  },
  addRectFilled() {
    this.addRect(true);
  },
  addCircle(fill) {
    this.mode = this.ModeEnum.circle;
    this.activeStrokeColour = 'red';
    if (fill) {
      this.activeFillColour = 'red';
    } else {
      this.activeFillColour = "none";
    }
  },
  addCircleFilled () {
    this.addCircle(true);
  },
  addCircleEmpty () {
    this.addCircle();
  },
  addText(text) {
    this.activeShape = this.snap.text(this.MAX_WIDTH/2, this.MAX_HEIGHT/2, text);
    this.activeShape.attr({strokeWidth: 4});
    this.activeShape.ftInitShape();
    this.mode = this.ModeEnum.none;
  },
  addLine(arrow) {
    this.activeStrokeColour = 'red';
    this.mode = this.ModeEnum.line;
  },
  addArrow() {
    this.activeStrokeColour = 'red';
    this.mode = this.ModeEnum.arrow;
  },
  addImage(url, coords) {
    this.mode = this.ModeEnum.image;
    var r = this.snap.image(url ,coords.x, coords.y, coords.width, coords.height).transform('r0.1');
    this.setStyle(r);
    this.prepareNewElement(r);
  },
  addScribbleEmpty(){
    this.addScribble();
  },
  inputText(){
    this.mode = this.ModeEnum.text;
    this.setState({});
  },
  addScribbleFilled(){
    this.addScribble(true);
  },
  addScribble(full) {
    if (full) {
      this.mode = this.ModeEnum.scribbleFill;
      this.activeFillColour = 'red';
    } else {
      this.activeFillColour = "none";
      this.mode = this.ModeEnum.scribble;
    }
    this.activeStrokeColour = 'red';
  },
  prepareNewElement(el) {
    el.ftSetSelectedCallback(this.shapeSelected);
    el.ftSetTransformedCallback(this.shapeTransformed);
  },
  addInputControl(el) {
    el.ftCreateHandles();
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
    return({x: Number(e.clientX), y: Number(e.clientY)});
  },
  sendObjectData(action) {
    var currentStrokeWidth = 3;
    var actualStrokeWidth = 5;
    var	currentAttr = {
			"title":		/*me.userName*/"tst" + "\'s drawing",
		//	"stroke":		self.attribute["stroke"],
		//	"stroke-width":	currentStrokeWidth
		};

		var	actualAttr = {
			"title":		/*me.userName*/ "tst" + "\'s drawing",
		//	"stroke":		self.attribute["stroke"],
		//	"stroke-width":	actualStrokeWidth
		};
    console.log("____", this.activeShape);
		//	lets set up most of message
		var	message = {
		//	id:				uid,
      id: this.activeShape.id,
		//	name:			/*me.userName*/"tst",
			//type:			'scribble',
      action: "draw",
			eventType:			action,
			//path:			me.path,
			attr:			actualAttr,
			strokeWidth:	actualStrokeWidth
		};

    message.element = this.activeShape;
    var messageJSON = {
      type: 'sendobject',
      message: message
    }
    window.sendMessage(messageJSON);
  },
  handleObjectCreated(){
    if (this.activeShape && !this.activeShape.created) {
      this.activeShape.created = true;
      this.prepareNewElement(this.activeShape);
      this.addInputControl(this.activeShape);
      var temp = this.activeShape;
      this.sendObjectData('draw');
      this.shapes[this.activeShape.id] = this.activeShape;
      //this.deleteActive();
    }
    this.coords = null;
    this.activeShape = null;
  },
  handleMouseDown: function(e){
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;
    this.coords = this.eventCoords(e);
    var bounds = e.target.getBoundingClientRect();
    this.canvasCoords = {x: Number(bounds.left), y: Number(bounds.top)};
    this.coords = {x: this.coords.x - this.canvasCoords.x, y: this.coords.y - this.canvasCoords.y};


    this.strokeColour = this.activeStrokeColour;
    this.fillColour = this.activeFillColour;
    this.fillNone = 'none';

  },
  handleMouseUp: function(e){
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;
    this.handleObjectCreated();
  },
  handleMouseMove(e) {
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;

    if (!this.coords) return;


    var coordsMove = this.eventCoords(e);
    coordsMove = {x: coordsMove.x - this.canvasCoords.x, y: coordsMove.y - this.canvasCoords.y};

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
        var arrow = this.snap.polygon([0,10, 4,10, 2,0, 0,10]).attr({fill: this.strokeColour}).transform('r270');
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
    this.setState({minimized: this.minimized});
  },
  getWidth() {
    if (this.minimized) {
      return this.MIN_WIDTH;
    } else {
      return this.MAX_WIDTH;
    }
  },
  getHeight() {
    if (this.minimized) {
      return this.MIN_HEIGHT;
    } else {
      return this.MAX_HEIGHT + 50;
    }
  },
  getExpandButtonImage() {
    if (this.minimized) {
      return "/images/icon_whiteboard_expand.png";
    } else {
      return "/images/icon_whiteboard_shrink.png";
    }
  },
  getMinimizedScale() {
    return this.MIN_HEIGHT/this.MAX_HEIGHT;
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
  onOpen(e) {
  },
  onClose(e) {
    this.mode = this.ModeEnum.none;
    this.setState({});
  },
  onAcceptText(e) {
    this.activeShape = this.addText(this.state.addTextValue);
    this.mode = this.ModeEnum.none;

    this.handleObjectCreated();
    this.setState({});
  },
  onSave(e) {
    this.onClose(e);
  },
  validationState() {
    let length = this.refs.input.getValue().length;
    let style = 'danger';
    if (length > 10) style = 'success';
    else if (length > 5) style = 'warning';

    let disabled = style !== 'success';

    return { addTextDisabled : disabled, addTextValue: this.refs.input.getValue() };
  },
  handleTextChange() {
    this.setState( this.validationState() );
  },
  render() {

    var cornerRadius = "5";
    var speed = "0.3s";
    var scale = this.minimized?this.getMinimizedScale():1.0;
    var scaleParam = 'width ' + speed +' ease-in-out, height ' + speed + ' ease-in-out';
    var divStyle = {
      borderRadius: cornerRadius,
      position: "absolute",
      top: '10px',
      right: '10px',
      WebkitTransition: 'all',
      msTransition: 'all',
      width: this.getWidth()+'px',
      height: this.getHeight()+'px',
      'WebkitTransition': scaleParam,
      'MozTransition': scaleParam,
      'OTransition': scaleParam,
      transition: scaleParam,
      background: this.WHITEBOARD_BACKGROUND_COLOUR,
      borderColor: this.WHITEBOARD_BORDER_COLOUR,
      borderWidth: 1,
      zIndex: 1000,
      padding: 10 + 'px'
    };

    var scaleSVGStyle = {
      'transformOrigin': '0 0',
      transform: 'scale('+scale+')',
      transition: 'transform ' + speed + ' ease-in-out',
      borderRadius: cornerRadius,
      borderWidth: 3,
      background: 'white',
      borderColor: this.WHITEBOARD_CANVAS_BORDER_COLOUR,
      width: this.MAX_WIDTH - 20/scale + 'px',
      height: this.MAX_HEIGHT - 20/scale + 'px',

    }

    var panelStyle = {
      position: 'absolute',
      top: 0,
      width: '100%'/*,
      WebkitTouchCallout: 'none',
      WebkitUserSelect: 'none',
      KhtmlUserSelect: 'none',
      MozUserSelect: 'none',
      MsUserSelect: 'none',
      UserSelect: 'none'*/
    }

    var panelStyleBottom = {
      position: 'absolute',
      bottom: 0,
      width: '100%',
      display: this.isMinimized()?'none':'block'
    }

    const { show, onHide, boardContent } = this.props;

    return (
      <div style={divStyle} className="container">
        <svg id={ this.getName() }
          style={scaleSVGStyle}
          onMouseDown={ this.handleMouseDown }
          onMouseUp={ this.handleMouseUp }
          onMouseMove={ this.handleMouseMove }
        />

        <div className="row" style={panelStyle}>
          <div id="title-whiteboard" className="col-sm-3">
            <img src={"/images/title_whiteboard.png"}/>
          </div>
          <div onClick={ this.expand } id="expand" className="col-sm-3 pull-right">
            <img className="pull-right" src={this.getExpandButtonImage()}/>
          </div>
        </div>

        <ButtonToolbar className="row col-sm-12 pull-right" style={panelStyleBottom}>
              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="circleShapes">
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addCircleEmpty}>Circle</Button>
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addCircleFilled}>Circle Filled</Button>
                  </Popover>
                }>
                <Button bsStyle="default">Circle</Button>
              </OverlayTrigger>

              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="rectShapes">
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addRectEmpty}>Rect</Button>
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addRectFilled}>Rect Filled</Button>
                  </Popover>
                }>
                <Button bsStyle="default">Rectangle</Button>
              </OverlayTrigger>

              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="scribleShapes">
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addScribbleEmpty}>Scribble</Button>
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addScribbleFilled}>Scribble Filled</Button>
                  </Popover>
                }>
                <Button bsStyle="default">Scribble</Button>
              </OverlayTrigger>

              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="lineWidthShapes">
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addScribbleEmpty}>2</Button>
                    <Button className="btn btn-primary btn-sm pull-right" onClick={this.addScribbleFilled}>3</Button>
                  </Popover>
                }>
                <Button bsStyle="default">Line Width</Button>
              </OverlayTrigger>

              <Button bsStyle="default" className="btn btn-sm pull-left" onClick={this.addLine}>Line</Button>
              <Button bsStyle="default" className="btn btn-sm pull-left" onClick={this.addArrow}>Arrow</Button>
              <Button bsStyle="default" className="btn btn-sm pull-left" onClick={this.inputText}>Text</Button>

              <Button bsStyle="warning" className="btn btn-primary btn-sm pull-left" onClick={this.deleteActive}>Delete Active</Button>
        </ButtonToolbar>

        <Modal dialogClassName='modal-section facilitator-board-modal' show={ this.mode == this.ModeEnum.text } onHide={ onHide } onEnter={ this.onOpen }>
          <Modal.Header>
            <div className='col-md-2'>
              <span className='pull-left fa icon-reply' onClick={ this.onClose }></span>
            </div>

            <div className='col-md-8 modal-title'>
              <h4>Enter Text</h4>
            </div>

            <div className='col-md-2' onClick={ this.onAcceptText } disabled={this.state.addTextDisabled}>
              <span className='pull-right fa fa-check'></span>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row facilitator-board-section'>
              <Input type="text" ref="input" onChange={this.handleTextChange} />
            </div>
          </Modal.Body>
        </Modal>
      </div>
    )
  }
});
const mapStateToProps = (state) => {
  return {
    whiteboard: state.whiteboard,
    channal: state.topic.channel,
    currentUser: state.members.currentUser,
  }
};
export default connect(mapStateToProps)(WhiteboardCanvas);

//export default WhiteboardCanvas;
