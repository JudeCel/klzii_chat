import React, {PropTypes}     from 'react';
import Snap                   from 'snapsvg';
import { OverlayTrigger, Button, Popover, ButtonToolbar, Input}    from 'react-bootstrap'
import whiteboardActions      from '../../actions/whiteboard'
import { connect }            from 'react-redux';
require("./drawControlls");
import undoHistoryFactory     from './actionHistory';
import mixins                 from '../../mixins';
import ReactDOM               from 'react-dom';
import ButtonPanel            from './panel';

const WhiteboardCanvas = React.createClass({
  mixins: [mixins.validations],
  getInitialState:function() {
    this.minimized = true;
    this.shapes = {};
    this.scaling = false;
    this.MIN_WIDTH = 316;
    this.MIN_HEIGHT = 153;
    this.MAX_WIDTH = 950;
    this.MAX_HEIGHT = 460;
    this.ModeEnum = {
      none: 0,
      emptyRect: 1,
      filledRect: 2,
      emptyCircle: 3,
      filledCircle: 4,
      filledScribble: 5,
      emptyScribble: 6,
      line: 7,
      arrow: 8,
      text: 9,
      image: 10,
      erase: 11
    };
    this.mode = this.ModeEnum.none;

    this.historyStep = {
      none: 0,
      next: 1,
      previous: 2
    };

    this.lastStep = this.historyStep.none;

    this.strokeWidthArray = [2, 4, 6];
    this.strokeWidth = this.strokeWidthArray[0];

    return { minimized: true };
  },
  componentDidMount() {
    this.snap = Snap("#" + this.getName());
    this.snapGroup = this.snap.group();

    this.activeShape = null;
    this.initUnselectCallback();
    this.componentWillReceiveProps(this.props);
    this.scaleWhiteboard();
  },
  componentDidUpdate(nextProps, nextState) {
    let screenChange = JSON.stringify(nextProps.utilityWindow) != JSON.stringify(this.props.utilityWindow);
    if(this.state.minimized != nextState.minimized || screenChange) {
      this.scaleWhiteboard();
    }
  },
  componentWillReceiveProps(nextProps, privProps) {
    if (nextProps.channel) {
      if (nextProps.shapes != this.shapes) {
        this.processWhiteboard(nextProps.shapes);
      }
      this.activeColour = this.props.currentUser.colour;
      this.activeStrokeColour = this.activeColour;
    }
  },
  handleHistoryObject(currentStep, reverse) {
    let self = this;
    if (currentStep) {
      //case when deleting/recreating shapes
      if (currentStep instanceof Array) {
        currentStep.map(function(element) {
          self.processHistoryStep(element, reverse);
        });
      } else {
        self.processHistoryStep(currentStep, reverse);
      }
    }
  },
  isUpdateEvent(step) {
    if (step) {
      let isUpdate = step.eventType == "update";
      if (isUpdate == false) {
        this.lastStep = this.historyStep.none;
      }
      return isUpdate;
    } else {
      return false;
    }
  },
  undoStep() {
    let step = undoHistoryFactory.undoStepObject();
    this.handleHistoryObject(step, true);
  },
  redoStep() {
    let step = undoHistoryFactory.redoStepObject();
    this.handleHistoryObject(step, false);
  },
  processHistoryStep(currentStepBase, reverse) {
    let currentHistoryStep = JSON.parse(JSON.stringify(currentStepBase));
    let currentStep;
    if (reverse) {
      if (currentHistoryStep.oldState) {
        currentStep = currentHistoryStep.oldState;
      } else {
        currentStep = currentHistoryStep;
      }
      if (currentStep.eventType == "delete") {
        currentStep.eventType = "draw";
      } else if (currentStep.eventType == "draw") {
        currentStep.eventType = "delete";
      }
    } else {
      if (currentHistoryStep.newState) {
        currentStep = currentHistoryStep.newState;
      } else {
        currentStep = currentHistoryStep;
      }
    }
    this.sendMessage(currentStep);
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
  canEditShape(item) {
    return (item.permissions.can_edit);
  },
  shouldCreateHandles(obj) {
    return (obj.permissions.can_edit || obj.permissions.can_delete);
  },
  processShapeData(item) {
    let event = item.event;
    var self = this;
    var obj = self.shapes[event.id];
    if (event.action != "delete" && !obj) {
      switch (event.element.type) {
        case "ellipse":
          obj = self.snap.ellipse(0, 0, 0, 0).transform('r0.1');
          this.snapGroup.add(obj);
          break;
        case "rect":
          obj = self.snap.rect(0, 0, 0, 0).transform('r0.1');
          this.snapGroup.add(obj);
          break;
        case "polyline":
          obj = self.snap.polyline([]).transform('r0.1');
          this.snapGroup.add(obj);
          break;
        case "line":
          obj = self.snap.line(0, 0, 0, 0).transform('r0.1');
          this.snapGroup.add(obj);
          break;
        case "text":
          obj = self.snap.text(0, 0, event.element.attr.textVal).transform('r0.1');
          this.snapGroup.add(obj);
          break;
        case "image":
          obj = self.snap.image(event.element.attr.href, 0, 0, 0, 0).transform('r0.1');
          this.snapGroup.add(obj);
          break;
        default:
          break;
      };
    }

    if (obj) {
      obj.permissions = item.permissions;
      if (!obj.created && self.shouldCreateHandles(obj)) {
        self.prepareNewElement(obj);
        obj.created = true;
      }
    }

    if (obj) {
      if (event.action == "delete") {
        obj.ftRemove();
        self.shapes[event.id] = null;
      } else {
        var attrs = (event.element.attr instanceof Function)?event.element.attr():event.element.attr;
        obj.attr(attrs);
        obj.created = true;
        if (!self.shapes[event.id]) {
          obj.id = event.id;
          let newShapes = {...self.shapes}
          newShapes[event.id] = obj;
          self.shapes = newShapes;
        }

        //check if arrow
        if (event.element.attr.style && event.element.attr.style.indexOf("marker") != -1) {
          obj.attr({markerStart: self.getArrowShape(event.element.attr.stroke)});
        }

        if (self.activeShape && obj.id == self.activeShape.id) {
          self.activeShape.ftCreateHandles();
        }
      }
    }
  },
  //process incoming messages about shapes from remote users
  processWhiteboard(data) {
    let self = this;
    var dataKeys = Object.keys(data);
    var shapesKeys = Object.keys(self.shapes)
    let keysToDelete = [];
    dataKeys.map((key) => {
      let item = data[key]
      self.processShapeData(item);
      keysToDelete.push(key);
    });

    var polygons = document.getElementsByTagName("polygon");
    var polygonsList = Array.prototype.slice.call(polygons);
    self.fixArrowsForIE();

    while (keysToDelete.length) {
      let position = shapesKeys.indexOf(keysToDelete[0]);
      if (position >-1) {
        shapesKeys.splice(position, 1);
      }
      keysToDelete.splice(0, 1);
    };


    let childrens = self.snapGroup.children();
    childrens.map(function(item) {
      let position = shapesKeys.indexOf(item.id)
      if (position > -1) {
        if (self.activeShape && self.activeShape.id == item.id) {
          self.activeShape = null;
        }
        self.shapes[item.id] = null;
        item.ftRemove();
      }
    });
  },
  addShapeStateToHistory(shape, action) {
    let message = this.prepareMessage(this.activeShape, action?action:'update');
    undoHistoryFactory.addStepToUndoHistory(message);
  },
  shapeFinishedTransform(shape) {
    this.activeShape = shape;
    this.sendObjectData('update');
    let message = this.prepareMessage(this.activeShape, 'update');
    //get step created in shapeStartedTransform() below
    let currentStep = undoHistoryFactory.currentStepObject();
    currentStep.newState = JSON.parse(JSON.stringify(message));
  },
  shapeStartedTransform(shape) {
    this.activeShape = shape;
    let message = this.prepareMessage(this.activeShape, 'update');
    undoHistoryFactory.addStepToUndoHistory({oldState: message});
  },
  shapeTransformed(shape) {
    this.activeShape = shape;
  },
  fixArrowsForIE() {
    //arrows fix for IE
    if(window.navigator.userAgent.indexOf("MSIE") > 0 || !!window.navigator.userAgent.match(/Trident.*rv\:11\./)){
      let lines = document.querySelectorAll("svg g line");
      var linesList = Array.prototype.slice.call(lines);
      linesList.forEach(function(el) {
        if(el.style.markerStart) {
          let polygonId = el.style.markerStart.replace('url("', '').replace('")', '');
          let strokeWidth = parseInt(el.style.strokeWidth);
          let polygon = document.querySelector(polygonId + " polygon");
          if (strokeWidth == 2) {
             polygon.setAttribute("points", "0,10 4,10 2,5 0,10");
          } else if (strokeWidth == 4) {
             polygon.setAttribute("points", "0,10 4,10 2,6 0,10");
             polygon.setAttribute("transform", "matrix(0 -1 1.1 0 -3 7)");
          } else if (strokeWidth == 6) {
             polygon.setAttribute("points", "0,10 4,10 2,7 0,10");
             polygon.setAttribute("transform", "matrix(0 -1 2 0 -5 7)");
          }
        }
      });
    }
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
  scaleWhiteboard() {
    let whiteboard = ReactDOM.findDOMNode(this);
    let scaleX = this.minimized ? (whiteboard.scrollWidth)/(this.MAX_WIDTH) : 1.0;
    let scaleY = this.minimized ? (whiteboard.scrollHeight)/(this.MAX_HEIGHT) : 1.0;
    this.snapGroup.transform(`S${scaleX},${scaleY},0,0`);
    this.snapGroup.attr({ pointerEvents: this.minimized ? 'none' : 'all' });
  },
  addText(text) {
    this.activeShape = this.snap.text(this.MAX_WIDTH/2 - text.length * 10, this.MAX_HEIGHT/2, text).transform('r0.1');
    this.setStyle(this.activeShape, this.activeFillColour, this.strokeWidth, this.activeStrokeColour);
    this.activeShape.attr({ 'font-size': '40px', textVal: text });
    this.snapGroup.add(this.activeShape);
    this.handleObjectCreated();
  },
  addImage(url) {
    this.activeShape = this.snap.image(url, 10, 20, 200, 100).transform('r0.1');
    this.snapGroup.add(this.activeShape);
    this.handleObjectCreated();
  },
  prepareNewElement(el) {
    if (this.shouldCreateHandles(el)) {
      el.canEdit = true;
      el.ftSetupControls();
      el.ftSetSelectedCallback(this.shapeSelected);
      el.ftSetTransformedCallback(this.shapeTransformed);
      el.ftSetFinishedTransformCallback(this.shapeFinishedTransform);
      el.ftSetStartedTransformCallback(this.shapeStartedTransform);
    }
  },
  setStyle(el, colour, strokeWidth, strokeColour) {
    el.attr({'fill': colour, stroke: strokeColour, strokeWidth: strokeWidth});
  },
  shapeSelected(el, selected) {
    let self = this;
    if (selected){
      Object.keys(this.shapes).forEach(function(key, index) {
        if (self.shapes[key] && self.shapes[key].id != el.id) {
          self.shapes[key].ftUnselect();
        }
      });

      if (el) {
        self.activeShape = el;
      }
    }
  },
  getName() {
    return 'Whiteboard_';
  },
  eventCoords(e) {
    return this.isTouch(e) ? {x: Number(e.touches[0].pageX), y: Number(e.touches[0].pageY)} : {x: Number(e.clientX), y: Number(e.clientY)};
  },
  sendObjectData(action, mainAction) {
    let message = this.prepareMessage(this.activeShape, action, mainAction)
    this.sendMessage(message);
  },
  handleObjectCreated() {
    if (this.activeShape && !this.activeShape.created) {
      this.activeShape.created = true;
      //created shape locally
      if (!this.activeShape.permissions) {
        this.activeShape.permissions = {can_edit: true, can_delete: true};
      }
      this.prepareNewElement(this.activeShape);
      var temp = this.activeShape;
      this.sendObjectData('draw');
      this.shapes[this.activeShape.id] = this.activeShape;
      this.addShapeStateToHistory(temp, 'draw');
    }
    this.coords = null;
  },
  handleMouseDown: function(e){
    if (!this.hasPermission(['whiteboard', 'can_new_shape'])) return;
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
    /*if(this.isTouch(e)) {
      this.activeShape = null;
    }*/
  },
  isTouch(e) {
    return e.type.includes("touch");
  },
  getArrowShape(colour) {
    var arrow = this.snap.polygon([0,10, 4,10, 2,0, 0,10]).attr({fill: colour}).transform('r270');
    return arrow.marker(0,0, 10,10, 0,5);
  },
  handleMouseMove(e) {
    if (!this.hasPermission(['whiteboard', 'can_new_shape'])) return;
    if (!this.isValidButton(e)) return;
    if (this.minimized) return;
    if (!this.coords) return;
    var coordsMove = this.eventCoords(e);
    coordsMove = {x: coordsMove.x - this.canvasCoords.x, y: coordsMove.y - this.canvasCoords.y};

    var dx = coordsMove.x - this.coords.x;
    var dy = coordsMove.y - this.coords.y;

    if(!this.activeShape && this.moveDistance(dx, dy) > 10) {
      if (this.mode == this.ModeEnum.emptyScribble) {
        this.activeShape = this.snap.polyline([]).transform('r0.1');
        this.setStyle(this.activeShape, this.fillNone, this.strokeWidth, this.strokeColour);
      }

      if (this.mode == this.ModeEnum.filledScribble) {
        this.activeShape = this.snap.polyline([]).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
      }

      if ((this.mode == this.ModeEnum.emptyRect) || (this.mode == this.ModeEnum.filledRect)) {
        this.activeShape = this.snap.rect(this.coords.x, this.coords.y, 10, 10).transform('r0.1');
        this.setStyle(this.activeShape, this.fillColour, this.strokeWidth, this.strokeColour);
      }

      if ((this.mode == this.ModeEnum.emptyCircle) || (this.mode == this.ModeEnum.filledCircle)) {
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

      if(this.activeShape) {
        this.snapGroup.add(this.activeShape);
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
    }
  },
  isValidButton(e) {
    return (e && e.button == 0 || this.isTouch(e) && !e.button);
  },
  expand() {
    this.minimized = !this.minimized;
    this.setState({minimized: this.minimized});
    if(this.minimized && this.activeShape) {
      this.activeShape.ftUnselect();
    }
  },
  getExpandButtonImage() {
    if (this.minimized) {
      return "/images/icon_whiteboard_expand.png";
    } else {
      return "/images/icon_whiteboard_shrink.png";
    }
  },
  handleStrokeWidthChange() {
    if (this.activeShape) {
      let oldState = this.prepareMessage(this.activeShape, 'update');
      undoHistoryFactory.addStepToUndoHistory({oldState: oldState});

      this.activeShape.attr({strokeWidth: this.strokeWidth});
      this.sendObjectData('update');

      //save modified state of a shape
      let newState = this.prepareMessage(this.activeShape, 'update');
      //get step created in shapeStartedTransform() below
      let stepToUpdate = undoHistoryFactory.currentStepObject();
      stepToUpdate.newState = JSON.parse(JSON.stringify(newState));
    }
  },
  prepareMessage(shape, action, mainAction) {
    let	message = {
      id: shape.id,
      action: (mainAction || "draw")
    };

    message.element = shape;
    return {
      eventType: action,
      message: message
    }
  },
  deleteActive() {
    if (this.activeShape && this.activeShape.permissions.can_delete) {
      let message = this.prepareMessage(this.activeShape, "delete");
      undoHistoryFactory.addStepToUndoHistory(message);

      this.sendObjectData('delete');
      this.activeShape.ftRemove();
      this.shapes[this.activeShape.id] = null;
      this.activeShape = null;
    }
  },
  deleteAll() {
    var messageJSON = {
      eventType: 'deleteAll',
      message: { action: 'deleteAll' }
    };
    this.sendMessage(messageJSON);
    undoHistoryFactory.addStepToUndoHistory(this.addAllDeletedObjectsToHistory(this.shapes));
  },
  addAllDeletedObjectsToHistory(shapes) {
    let objects = [];
    let self = this;
    Object.keys(shapes).forEach(function(key, index) {
      let element = shapes[key];
      if (element) {
        objects.push(self.prepareMessage(element, "delete"));
      }
    });
    return objects;
  },
  changeButton(params) {
    const { mode, data } = params;
    this.mode = mode ? this.ModeEnum[mode] : this.mode;
    this.setState({ mode: mode });
    this.activeFillColour = this.activeColour;
    this.activeStrokeColour = this.activeColour;

    switch(this.mode) {
      case this.ModeEnum.emptyRect:
      case this.ModeEnum.emptyCircle:
      case this.ModeEnum.emptyScribble:
        this.activeFillColour = 'none';
        break;
      default:
    }

    if(!data) return;

    if(data.mode == 'strokeWidth') {
      this.strokeWidth = data.width;
      this.handleStrokeWidthChange();
    }

    if(data.mode == 'deleteActive') {
      this.deleteActive();
    }

    if(data.mode == 'deleteAll') {
      this.deleteAll();
    }

    if(data.mode == 'stepRedo') {
      this.redoStep();
    }

    if(data.mode == 'stepUndo') {
      this.undoStep();
    }

    if(data.mode == 'text') {
      this.addText(data.text);
    }

    if(data.mode == 'image') {
      this.addImage(data.url);
    }
  },
  renderButtonPanel(){
    if (this.hasPermission(['whiteboard', 'can_new_shape'])){
      return <ButtonPanel changeButton={ this.changeButton } mode={ this.mode } enum={ this.ModeEnum } />
    };
  },
  render() {
    if(this.props.channel) {
      return (
        <div id='whiteboard-box' className={ 'whiteboard-section' + (this.minimized ? ' minimized' : ' maximized') }>
          <span className="icon-whiteboard-hide-mobile" onClick={ this.expand }></span>
          <img className='whiteboard-title' src='/images/title_whiteboard.png' />
          <img className='whiteboard-expand' src={ this.getExpandButtonImage() } onClick={ this.expand } />

          <svg id={ this.getName() } className='inline-board-section'
            onMouseDown={ this.handleMouseDown }
            onMouseUp={ this.handleMouseUp }
            onMouseMove={ this.handleMouseMove }
            onTouchStart={ this.handleMouseDown }
            onTouchEnd={ this.handleMouseUp }
            onTouchMove={ this.handleMouseMove }
          />
        {this.renderButtonPanel()}
        </div>
      )
    }
    else {
      return (false);
    }
  }
});

const mapStateToProps = (state) => {
  return {
    shapes: state.whiteboard.shapes,
    channel: state.whiteboard.channel,
    currentUser: state.members.currentUser,
    utilityWindow: state.utility.window
  }
};

export default connect(mapStateToProps)(WhiteboardCanvas);
