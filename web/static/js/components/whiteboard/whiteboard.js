import React        from 'react';
import { connect }  from 'react-redux';
import SVG          from 'svgjs';
import svgDraw      from 'svg.draw.js';
import svgDrag      from 'svg.draggable.js';
import svgResize    from 'svg.resize.js';
import svgSelect    from 'svg.select.js';

import mixins       from '../../mixins';

import Events       from './events';
import Shape        from './shape';
import Design       from './design';
import Toolbar      from './toolbar';
import Elements     from './elements';
import History      from './history';
import Actions      from './actions';
import Helpers      from './helpers';
import ReactDOM     from 'react-dom';
import svgPosition  from 'svg.pan-zoom.js';
import touchHandler       from './touchHandler';

const Whiteboard = React.createClass({
  mixins:[Design, mixins.validations, touchHandler, mixins.mobileHelpers],
  initDefs() {
    this.markers = this.markers || { arrows: {} };

    let array = [this.props.facilitator, ...this.props.participants];
    array.map(function(member) {
      this.createArrowTip(member.id, member.colour);
    }, this);
  },
  createArrowTip(id, color) {
    if (!this.markers.arrows[id]) {
      let marker = this.board.defs().marker(10, 10).attr({ id: 'marker-arrow-' + id, 'stroke': 'none', orient: 'auto', fill: color, 'viewBox': "0 0 10 10" , strokeWidth: '0 !important'} );
      marker.path('M 0 0 L 10 5 L 0 10 z');
      this.markers.arrows[id] = marker;
    }
  },
  initScale() {
    const { minimized } = this.state;
    if(minimized) {
      this.mouseData.type = 'none';
      this.deps.Shape.deselectShape();
    }
    else {
      this.mouseData.type = 'select';
    }
    this.pinchHandler = this.mainGroup.panZoom({ zoom: [1, this.isMobile() ? 1.5 : 1] });
    this.board.attr({ 'pointer-events': minimized ? 'none' : 'all' });
  },
  initDependencies() {
    this.deps = {};
    this.deps.Events = Events.init(this);
    this.deps.Shape = Shape.init(this);
    this.deps.Toolbar = Toolbar.init(this);
    this.deps.Elements = Elements.init(this);
    this.deps.History = History.init(this);
    this.deps.Actions = Actions.init(this);
    this.deps.Helpers = Helpers.init(this);
  },
  initBoardEvents() {
    this.board.on('mousedown', Events.boardMouseDown);
    this.board.on('mouseup', Events.boardMouseUp);
    this.board.on('mousemove', Events.boardMouseMove);
    this.board.on('mouseleave', Events.boardMouseLeave);

    this.board.on('touchstart', this.processInput);
    this.board.on('touchmove', this.processInput);
    this.board.on('touchend', this.processInput);
  },
  getInitialState() {
    this.mouseData = { type: 'none', prevType: null, selected: null };
    this.shapeData = { shape: {}, added: {} };
    this.drawData = {
      initialWidth: 925,
      initialHeight: 465,
      strokeWidth: 2,
      current: 'none',
      color: 'red',
      imageUrl: '',
      text: ''
    };
    this.drawData.minsMaxs = {
      minX: 10,
      minY: 10,
      maxX: this.drawData.initialWidth,
      maxY: this.drawData.initialHeight
    };

    this.initDependencies();
    return { minimized: true, zoomEnabled: false };
  },
  componentDidUpdate(prevProps, prevState) {
    this.drawData.color = this.props.currentUser.colour;
    let screenChange = prevProps.utilityWindow != this.props.utilityWindow;
    if(prevProps.shapes != this.props.shapes) {
      this.deps.Shape.loadShapes();
    }
    else if(prevState.minimized != this.state.minimized || screenChange) {
      this.initScale();
    }
    else if(JSON.stringify(prevProps.participants) != JSON.stringify(this.props.participants)) {
      this.initDefs();
    }
  },
  componentDidMount() {
    this.board = SVG('whiteboard-draw');
    this.mainGroup = this.board.group();
    this.board.size("100%", "100%");
    let boxSize = "0 0 " + this.drawData.initialWidth + " " + this.drawData.initialHeight;
    this.board.attr({viewBox: boxSize, preserveAspectRatio: "xMidYMid meet" });
    this.mainGroup.attr({viewBox: boxSize, preserveAspectRatio: "xMidYMid meet", width: "100%", height: this.drawData.initialHeight, x: 0, y: 0 });
    this.mainGroup.size(this.drawData.initialWidth, this.drawData.initialHeight);
    this.initDefs();
    this.initScale();
    this.initBoardEvents();
    this.deps.Shape.loadShapes();
  },
  zoomEnabled (enabled) {
    if (enabled != this.state.zoomEnabled) {
      this.setState({zoomEnabled: enabled});
    }
  },
  getCurrentZoom() {
    return this.pinchHandler.transform ? this.pinchHandler.transform.scaleX : 1;
  },
  zoom(zoomIn) {
    let scale = this.getCurrentZoom();
    if (zoomIn) {
      scale += 0.1;
    } else {
      scale -= 0.1;
    }
    this.pinchHandler.zoom(scale);
  },
  resetZoom() {
    let scale = this.getCurrentZoom();
    if (this.pinchHandler.transform) {
      this.pinchHandler.transform.x = 0;
      this.pinchHandler.transform.y = 0;
      this.pinchHandler.zoom(1);
    }
  },
  svgClass() {
    let svgStyle = "inline-board-section";
    if (this.state.zoomEnabled) {
      svgStyle += " zooming";
    }
    return svgStyle;
  },
  render() {
    if(this.props.channel) {
      return (
        <div id='whiteboard-box' className={'whiteboard-section' + this.expandButtonClass() }>
          <span className="icon-whiteboard-hide-mobile" onClick={ this.expandWhiteboard }></span>

          <img className='whiteboard-title' src='/images/title_whiteboard.png' />
          <img className='whiteboard-expand' src={ this.getExpandButtonImage() } onClick={ this.expandWhiteboard } />

          <div className="full-height-width" >
            <svg id='whiteboard-draw' className={ this.svgClass() } preserveAspectRatio="xMidYMid meet"/>
          </div>
          { this.showToolbar()}
        </div>
      );
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
    facilitator: state.members.facilitator,
    participants: state.members.participants,
    utilityWindow: state.utility.window
  }
};

export default connect(mapStateToProps)(Whiteboard);
