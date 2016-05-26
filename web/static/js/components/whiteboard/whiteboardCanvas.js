import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';
import { OverlayTrigger, Button, Popover, ButtonToolbar, Input}    from 'react-bootstrap'
import { Modal }          from 'react-bootstrap'
import whiteboardActions    from '../../actions/whiteboard'
import { connect }          from 'react-redux';
require("./drawControlls");

const WhiteboardCanvas = React.createClass({
  getInitialState:function() {
    this.undoHistory = [];
    this.undoHistoryIdx = 0;

    this.minimized = true;
    this.scaling = false;
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
      rectangleFill: 2,
      circle: 3,
      circleFill: 4,
      scribble: 5,
      scribbleFill: 6,
      line: 7,
      arrow: 8,
      text: 9,
      image: 10,
      erase: 11
    };
    this.mode = this.ModeEnum.none;

    this.strokeWidthArray = [2, 4, 6];
    this.strokeWidth = this.strokeWidthArray[0];

    return {shapes: {}, content: '', addTextDisabled: true, addTextValue: ''};
  },
  addStepToUndoHistory(json) {
    var self = this;
    //if made a few undo steps, then delete next redo steps first
    if (self.undoHistoryIdx > 0 && self.undoHistoryIdx < self.undoHistory.length) {
      self.undoHistory.slice(0, self.undoHistoryIdx );
    }
    self.undoHistory.push(json);
    self.undoHistoryIdx = self.undoHistory.length;
  },
  addAllDeletedObjectsToHistory() {
    let self = this;
    let objects = [];
    Object.keys(this.state.shapes).forEach(function(key, index) {
      let element = self.state.shapes[key]
      if (element) {
        objects.push(self.prepareMessage(element, "delete"));
      }
    });
    this.addStepToUndoHistory(objects);
  },
  handleHistoryObject(idx, reverse) {
    let self = this
    let currentStep = self.undoHistory[this.undoHistoryIdx];
    if (currentStep instanceof Array) {
      currentStep.map(function(element) {
        self.processHistoryStep(element, reverse);
      });
    } else {
      self.processHistoryStep(currentStep, reverse);
    }
  },
  undoStep() {
    this.undoHistoryIdx--;
    if (this.undoHistoryIdx < 0) {
      this.undoHistoryIdx = 0;
      return;
    }
    this.handleHistoryObject(this.undoHistoryIdx, true);
  },
  redoStep() {
    this.undoHistoryIdx++;
    if (this.undoHistoryIdx > this.undoHistory.length - 1) {
      this.undoHistoryIdx = this.undoHistory.length - 1;
      return;
    }
    this.handleHistoryObject(this.undoHistoryIdx, false);
  },
  processHistoryStep(currentStep, reverse) {
    if (reverse) {
      if (currentStep.eventType == "delete") {
        currentStep.eventType = "draw";
      } else if (currentStep.eventType == "draw") {
        currentStep.eventType = "delete";
      }
    }
    this.sendMessage(currentStep);
  },
  processHistory(json){
    if (json.eventType == "deleteAll") {
      this.addAllDeletedObjectsToHistory();
    } else {
      this.addStepToUndoHistory(json);
    }
  },
  sendMessage(json) {
    switch (json.eventType) {
      case 'draw':
        this.props.dispatch(whiteboardActions.create(this.props.channel, json.message));
        break;
      case 'update':
        this.props.dispatch(whiteboardActions.update(this.props.channel, json.message));
        break;
      case 'deleteAll':
        this.props.dispatch(whiteboardActions.deleteAll(this.props.channel));
        break;
      case 'delete':
        this.props.dispatch(whiteboardActions.delete(this.props.channel, json.message.id));
        break;
      default:
    }
  },
  componentWillReceiveProps(nextProps, privProps) {
    if (nextProps.channel) {
      if (nextProps.shapes != privProps.shapes) {
        this.processWhiteboard(nextProps.shapes)
      }
      this.activeColour = this.props.currentUser.colour;
      this.activeStrokeColour = this.activeColour;
    }
  },
  isFacilitator() {
    return this.props.currentUser.role == "facilitator";
  },
  canEditShape(item) {
    return (this.isFacilitator() || item.userName == this.props.currentUser.username);
  },
  processShapeData(event) {
    var self = this;
    var obj = self.state.shapes[event.id];
    if (event.eventType != "delete" && !obj) {
      switch (event.element.type) {
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
        case "text":
          obj = self.snap.text(0, 0, event.element.attr.textVal).transform('r0.1');
          break;
        case "image":
          obj = self.snap.image(event.element.attr.href, 0, 0, 0, 0).transform('r0.1');
          break;
        default:
          break;
      };
      if (obj && !obj.created && self.canEditShape(event)) {
        self.prepareNewElement(obj);
        obj.created = true;
      }
    }

    if (obj){

      if (event.eventType == "delete") {
        obj.ftRemove();
        let newShapes = {...self.state.shapes}
        newShapes[event.id] = null
        self.setState({shapes: newShapes})
      } else {
        var attrs = (event.element.attr instanceof Function)?event.element.attr():event.element.attr;
        obj.attr(attrs);
        obj.created = true;

        if (!self.state.shapes[event.id]) {
          obj.id = event.id;
          let newShapes = {...self.state.shapes}
          newShapes[event.id] = obj;
          self.setState({shapes: newShapes})
        }

        //check if arrow
        if (event.element.attr.style && event.element.attr.style.indexOf("marker") != -1) {
          obj.attr({markerStart: self.getArrowShape(event.element.attr.stroke)});
        }
      }
    }
  },
  //process incoming messages about shapes from remote users
  processWhiteboard(data) {
    let self = this;
    var dataKeys = Object.keys(data);
    var shapesKeys = Object.keys(self.state.shapes)

    dataKeys.map((key) => {
      let item = data[key]
      let event = item.event;
      self.processShapeData(event);

      let position = shapesKeys.indexOf(key)
      if (position >-1) {
        shapesKeys.splice(position, 1);
      }
    });

    let childrens = self.snap.paper.children();
    childrens.map(function(item) {
      let position = shapesKeys.indexOf(item.id)
      if (position > -1) {
        item.remove();
      }
    });
  },
  deleteAllObjects() {
    this.snap.clear();
    this.setState({shapes: {}});
  },
  shapeFinishedTransform(shape) {
    this.activeShape = shape;
    this.sendObjectData('update');
  },
  shapeTransformed(shape) {
    this.activeShape = shape;
  },
  moveDistance(dx, dy) {
    return Math.sqrt( Math.pow( dx, 2)  + Math.pow( dy, 2)  );
  },
  initUnselectCallback() {
    var self = this;
    this.snap.drag( function(x, y, mEl) {
    }, function(x, y, mEl) {
      if (mEl.target.id == self.getName()) {
        if (self.activeShape) self.activeShape.ftUnselect();
        self.activeShape = null;
      }
    }, function(x, y, mEl) {
    } );
  },
  componentDidMount() {
    this.snap = Snap("#" + this.getName());

    this.activeShape = null;
    var self = this;
    this.initUnselectCallback();
  },
  setActiveFillColour(fill) {
    this.activeStrokeColour = this.activeColour;
    if (fill) {
      this.activeFillColour = this.activeColour;
    } else {
      this.activeFillColour = "none";
    }
  },
  addRect(fill) {
    this.setActiveFillColour(fill);
    this.setState({});
  },
  addRectEmpty() {
    this.mode = this.ModeEnum.rectangle;
    this.addRect();
  },
  addRectFilled() {
    this.mode = this.ModeEnum.rectangleFill;
    this.addRect(true);
  },
  addCircle(fill) {
    this.setState({});
    this.setActiveFillColour(fill);
  },
  addCircleFilled () {
    this.mode = this.ModeEnum.circleFill;
    this.addCircle(true);
  },
  addCircleEmpty () {
    this.mode = this.ModeEnum.circle;
    this.addCircle();
  },
  addText(text) {
    this.activeShape = this.snap.text(this.MAX_WIDTH/2, this.MAX_HEIGHT/2, text).transform('r0.1');
    this.mode = this.ModeEnum.none;
    this.setState({});
    this.fillColour = this.activeColour;
    this.activeFillColour = this.activeColour;
    this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
    this.activeShape.textValue = text;
    this.activeShape.attr({"font-size": "40px", textVal: text});

    return this.activeShape;
  },
  addLine(arrow) {
    this.activeStrokeColour = this.activeColour;
    this.mode = this.ModeEnum.line;
    this.setState({});
  },
  addArrow() {
    this.activeStrokeColour = this.activeColour;
    this.mode = this.ModeEnum.arrow;
    this.setState({});
  },
  prepareImage() {
    this.addImage("/images/logo.png", 10, 20, 200, 100);
  },
  addImage(url, x, y, width, height) {
    this.mode = this.ModeEnum.image;
    this.setState({});
    this.activeShape = this.snap.image(url , x, y, width, height).transform('r0.1');
    this.handleObjectCreated();
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
    } else {
      this.mode = this.ModeEnum.scribble;
    }
    this.setState({});
    this.setActiveFillColour(full);
    this.activeStrokeColour = 'red';
  },
  prepareNewElement(el) {
    el.ftSetupControls();
    el.ftSetSelectedCallback(this.shapeSelected);
    el.ftSetTransformedCallback(this.shapeTransformed);
    el.ftSetFinishedTransformCallback(this.shapeFinishedTransform);
  },
  addInputControl(el) {
    el.ftSetupControls();
  },
  setStyle(el, colour, strokeWidth, strokeColour) {
    el.attr({'fill': colour, stroke: strokeColour, strokeWidth: strokeWidth});
  },
  shapeSelected(el, selected) {
    let self = this;
    if (selected){
      Object.keys(this.state.shapes).forEach(function(key, index) {
        if (self.state.shapes[key] && self.state.shapes[key].id != el.id) {
          self.state.shapes[key].ftUnselect();
        }
      });

      if (el) {
        self.activeShape = el;
      }
    }
  },
  deleteActive() {
    if (this.activeShape && this.canEditShape(this.activeShape)) {
      this.sendObjectData('delete');
      this.activeShape.ftRemove();
      this.activeShape = null;
    }
  },
  deleteAll() {
  	var message = {
  		action: "deleteAll"
  	};
  	var messageJSON = {
  		eventType: 'deleteAll',
  		message: message
  	};
    this.sendMessage(messageJSON);
    this.processHistory(messageJSON);
  },
  getName() {
    return 'Whiteboard_';
  },
  shouldComponentUpdate(nextProps) {
    return true;
  },
  componentDidUpdate() {
  },
  eventCoords(e) {
    return({x: Number(e.clientX), y: Number(e.clientY)});
  },
  prepareMessage(shape, action, mainAction) {
    var	message = {
      id: shape.id,
      action: (mainAction || "draw"),
      userName: this.props.currentUser.username
		};

    message.element = shape;
    return {
      eventType: action,
      message: message
    }
  },
  sendObjectData(action, mainAction) {
    let message = this.prepareMessage(this.activeShape, action, mainAction)
    this.sendMessage(message);
    this.processHistory(message);
  },
  handleObjectCreated() {
    if (this.activeShape && !this.activeShape.created) {
      this.activeShape.created = true;

      this.prepareNewElement(this.activeShape);
      var temp = this.activeShape;
      this.sendObjectData('draw');
      this.state.shapes[this.activeShape.id] = this.activeShape;
    }
    this.coords = null;
  },
  handleMouseDown: function(e){
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;
    if (this.scaling) return;
    this.coords = this.eventCoords(e);
    var bounds = e.target.getBoundingClientRect();
    this.canvasCoords = {x: Number(bounds.left), y: Number(bounds.top)};
    this.coords = {x: this.coords.x - this.canvasCoords.x, y: this.coords.y - this.canvasCoords.y};

    this.strokeColour = this.activeStrokeColour;
    this.fillColour = this.activeFillColour;
    this.fillNone = 'none';
  },
  handleMouseUp: function(e){
    if (this.scaling) return;
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;
    this.handleObjectCreated();
  },
  getArrowShape(colour) {
    var arrow = this.snap.polygon([0,10, 4,10, 2,0, 0,10]).attr({fill: colour}).transform('r270');
    return arrow.marker(0,0, 10,10, 0,5);
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
      if (this.mode == this.ModeEnum.scribble) {
        this.activeShape = this.snap.polyline([]).transform('r0.1');
        this.setStyle(this.activeShape, this.fillNone, this.strokeWidth, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.scribbleFill) {
        this.activeShape = this.snap.polyline([]).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
      }

      if ((this.mode == this.ModeEnum.rectangle) || (this.mode == this.ModeEnum.rectangleFill)) {
        this.activeShape = this.snap.rect(this.coords.x, this.coords.y, 10, 10).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
      }

      if ((this.mode == this.ModeEnum.circle) || (this.mode == this.ModeEnum.circleFill)) {
        this.activeShape = this.snap.ellipse(this.coords.x-2, this.coords.y-2, 4, 4).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.line) {
        this.activeShape = this.snap.line(this.coords.x, this.coords.y, this.coords.x + 1, this.coords.y + 1).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.arrow) {
        this.activeShape = this.snap.line(this.coords.x, this.coords.y, this.coords.x + 1, this.coords.y + 1).attr({markerStart: this.getArrowShape(this.strokeColour)}).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
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
  onOpen(e) {
  },
  onClose(e) {
    this.mode = this.ModeEnum.none;
    this.setState({});
  },
  onAcceptText(e) {
    this.setState({});
    this.activeShape = this.addText(this.state.addTextValue);
    this.mode = this.ModeEnum.none;

    this.handleObjectCreated();

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
  handleStrokeWidthChange(e) {
    this.strokeWidth = e.target.value;
    if (this.activeShape) {
      this.activeShape.attr({strokeWidth: this.strokeWidth});
      this.sendObjectData('update');
    }
    this.setState({});
  },
  toolStyle(toolType) {
    return "btn " + ((toolType == this.mode)?"btn-warning":"btn-default");
  },
  isLineWidthActive(el) {
    return "btn " + (( this.strokeWidth == el)?"btn-warning":"btn-default");
  },
  isShapeSectionActive() {
    var enabled = false;
    if (this.mode == this.ModeEnum.circle ||
      this.mode == this.ModeEnum.circleFill ||
      this.mode == this.ModeEnum.rectangle ||
      this.mode == this.ModeEnum.rectangleFill
    ) {
      enabled = true;
    }
    return "btn " + (enabled?"btn-warning":"btn-default");
  },
  isIrregularShapeSectionActive() {
    var enabled = false;
    if (this.mode == this.ModeEnum.scribble ||
      this.mode == this.ModeEnum.scribbleFill ||
      this.mode == this.ModeEnum.line ||
      this.mode == this.ModeEnum.arrow ||
      this.mode == this.ModeEnum.text
    ) {
      enabled = true;
    }
    return "btn " + (enabled?"btn-warning":"btn-default");
  },
  render() {
    const { show, onHide, boardContent, channel } = this.props;
    // not render if not set channel
    if (!channel) { return false }
    var self = this;
    var cornerRadius = 5;
    var speed = "0.3s";
    var scale = this.minimized?this.getMinimizedScale():1.0;
    var scaleParam = 'width ' + speed +' ease-in-out, height ' + speed + ' ease-in-out';
    var divStyle = {
      borderRadius: cornerRadius,
      position: "absolute",
      top: '10px',
      left: (window.innerWidth - this.getWidth()) / 3 + "px" ,
      WebkitTransition: 'all',
      msTransition: 'all',
      width: this.getWidth()+'px',
      height: this.getHeight()+'px',
      'WebkitTransition': scaleParam,
      'MozTransition': scaleParam,
      'OTransition': scaleParam,
      transition: scaleParam,
      border: "solid",
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
      borderWidth: 1,
      background: 'white',
      border: "solid",
      borderColor: this.WHITEBOARD_CANVAS_BORDER_COLOUR,
      width: this.MAX_WIDTH - 20/scale + 'px',
      height: this.MAX_HEIGHT - 20/scale + 'px',

    }

    var panelStyle = {
      position: 'absolute',
      top: 0,
      width: '100%'
    }

    var panelStyleBottom = {
      position: 'absolute',
      bottom: 10,
      left: 0,
      right: 0,
      display:'inline-block',
      'marginLeft': 'auto',
      'marginRight': 'auto',
      display: this.isMinimized()?'none':'block'
    }
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

        <ButtonToolbar className="row col-sm-4" style={panelStyleBottom}>
              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="circleShapes">
                    <i className={this.toolStyle(this.ModeEnum.circle)+" fa fa-circle-o"} aria-hidden="true" onClick={this.addCircleEmpty}></i>
                    <i className={this.toolStyle(this.ModeEnum.circleFill)+" fa fa-circle"} aria-hidden="true" onClick={this.addCircleFilled}></i>

                    <i className={this.toolStyle(this.ModeEnum.rectangle)+" fa fa-square-o"} aria-hidden="true" onClick={this.addRectEmpty}></i>
                    <i className={this.toolStyle(this.ModeEnum.rectangleFill)+" fa fa-square"} aria-hidden="true" onClick={this.addRectFilled}></i>
                    <i className={this.toolStyle(this.ModeEnum.image)+" fa fa-file-image-o"} aria-hidden="true" onClick={this.prepareImage}></i>
                  </Popover>
                }>
                <Button className={this.isShapeSectionActive()}><i className="fa fa-star" aria-hidden="true"></i></Button>
              </OverlayTrigger>

              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="scribleShapes">
                    <i className={this.toolStyle(this.ModeEnum.scribble)+" fa fa-scribd"} aria-hidden="true" onClick={this.addScribbleEmpty}></i>
                    <i className={this.toolStyle(this.ModeEnum.scribbleFill)+" fa fa-bookmark"} aria-hidden="true" onClick={this.addScribbleFilled}></i>

                    <i className={this.toolStyle(this.ModeEnum.line)} aria-hidden="true" onClick={this.addLine}>/</i>
                    <i className={this.toolStyle(this.ModeEnum.arrow)+" fa fa-long-arrow-right"} aria-hidden="true" onClick={this.addArrow}></i>
                    <i className={this.toolStyle(this.ModeEnum.text)} aria-hidden="true" onClick={this.inputText}>ABC</i>

                  </Popover>
                }>
                <Button className={this.isIrregularShapeSectionActive()}><i className="fa fa-pencil" aria-hidden="true"></i></Button>
              </OverlayTrigger>

              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="lineWidthShapes">
                    {this.strokeWidthArray.map(function(result) {
                      return <div className="radio" key={"radio" + result} >
                        <label className={self.isLineWidthActive(result)}><input type="radio" ref="strokeWidth" name="optradio" value={result} onClick={self.handleStrokeWidthChange}/>{result}/</label>
                      </div>
                    })}
                  </Popover>
                }>
                <Button bsStyle="default"><i className="fa fa-cog" aria-hidden="true"></i></Button>
              </OverlayTrigger>

              <OverlayTrigger trigger="focus" placement="top" overlay={
                  <Popover id="eraserShapes">
                    <i className="btn-sm fa fa-eraser" aria-hidden="true" onClick={this.deleteActive}>*</i>
                    <i className="btn-sm fa fa-eraser" aria-hidden="true" onClick={this.deleteAll}></i>
                  </Popover>
                }>
                <Button bsStyle="default"><i className="fa fa-eraser" aria-hidden="true"></i></Button>
              </OverlayTrigger>

              <Button bsStyle="default"><i className="fa fa-undo" aria-hidden="true" onClick={this.undoStep}></i></Button>
              <Button bsStyle="default"><i className="fa fa-repeat" aria-hidden="true" onClick={this.redoStep}></i></Button>
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
    shapes: state.whiteboard.shapes,
    channel: state.whiteboard.channel,
    currentUser: state.members.currentUser,
    resourceImages: state.resources.images
  }
};
export default connect(mapStateToProps)(WhiteboardCanvas);