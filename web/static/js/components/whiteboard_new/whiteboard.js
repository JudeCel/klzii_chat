import React        from 'react';
import { connect }  from 'react-redux';
import SVG          from 'svgjs';
import svgDraw      from 'svg.draw.js';
import svgDrag      from 'svg.draggable.js';
import svgResize    from 'svg.resize.js';
import svgSelect    from 'svg.select.js';

import mixins       from '../../mixins';

import Plugins      from './plugins';
import Events       from './events';
import Shape        from './shape';
import Design       from './design';
import Toolbar      from './toolbar';
import Elements     from './elements';
import History      from './history';
import Actions      from './actions';
import Helpers      from './helpers';
import ReactDOM     from 'react-dom';

const Whiteboard = React.createClass({
  mixins:[Design, mixins.validations],
  initDefs() {
    this.markers = { arrows: {} };

    let array = [this.props.facilitator, ...this.props.participants];
    array.map(function(member) {
      let marker = this.board.defs().marker(10, 10).attr({ id: 'marker-arrow-' + member.id });
      marker.polygon('0,2 0,8 10,5').attr({ fill: member.colour });
      this.markers.arrows[member.id] = marker;
    }, this);
  },
  initScale() {
    const { minimized } = this.state;
    let parent = this.board.parent();
    let scaleX = parent.scrollWidth/this.drawData.initialWidth;
    let scaleY = parent.scrollHeight/this.drawData.initialHeight;
    scaleX = scaleX > 1 ? 1 : scaleX;
    scaleY = scaleY > 1 ? 1 : scaleY;
    this.mainGroup.scale(scaleX, scaleY).translate(0, 0);
    this.board.attr({ 'pointer-events': minimized ? 'none' : 'all' });
  //  this.scaleWhiteboard();
  },
  isMobile() {
    return screen.width < 768 && screen.height < 768;
  },
  scaleWhiteboard() {
    let scale = 1.0;
    let shouldScale = this.minimized || window.innerWidth <= this.MAX_WIDTH + 50;
    let whiteboard = ReactDOM.findDOMNode(this);
    let isMobile = this.isMobile();
    let scaleW = (whiteboard.clientWidth - (this.minimized ? 10 : (isMobile ? -10 : 0))) / this.MAX_WIDTH;
    if (!isMobile) {
      whiteboard.style.height = (scaleW * this.MAX_HEIGHT - (this.minimized ? 5 : 0) ) + "px";
    }
    if (shouldScale) {
      let scaleH = (whiteboard.clientHeight - (isMobile ? 190 : 0)) / (this.MAX_HEIGHT - 60);
      scale = Math.min(scaleW, scaleH);
      if (isMobile) {
        let svgElement = whiteboard.childNodes[3];
        if (scale == scaleH) {
          let width = (this.MAX_WIDTH - 20) * scale;
          let height = whiteboard.clientHeight - 190;
          svgElement.style.width = width + "px";
          svgElement.style.marginLeft = ((whiteboard.clientWidth - width) / 2) + "px";
          svgElement.style.height = height + "px";
          svgElement.style.marginBottom = null;
        } else {
          let height = (this.MAX_HEIGHT - 60) * scale;
          svgElement.style.width = null;
          svgElement.style.marginLeft = null;
          svgElement.style.height = height + "px";
          svgElement.style.marginBottom = (whiteboard.clientHeight - 190 - height) + "px";
        }
        svgElement.style.marginTop = "60px";
      }
    }
    this.mainGroup.scale(scale, scale);
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
    this.board.mousedown(Events.boardMouseDown);
    document.addEventListener('mousemove', Events.boardMouseMove);
    document.addEventListener('mouseup', Events.boardMouseUp);


    this.board.on('touchstart', Events.boardMouseDown);
    this.board.on('touchmove', Events.boardMouseMove);
    this.board.on('touchend', Events.boardMouseUp);
  },
  getInitialState() {
    this.mouseData = { type: 'select', prevType: null, selected: null };
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
      minX: 0,
      minY: 0,
      maxX: this.drawData.initialWidth,
      maxY: this.drawData.initialHeight
    };

    this.initDependencies();
    return { minimized: true };
  },
  componentDidUpdate(prevProps, prevState) {
    this.drawData.color = this.props.currentUser.colour;
    let screenChange = JSON.stringify(prevProps.utilityWindow) != JSON.stringify(this.props.utilityWindow);

    if(prevProps.shapes != this.props.shapes) {
      this.deps.Shape.loadShapes();
    }
    else if(prevState.minimized != this.state.minimized || screenChange) {
      if(this.state.minimized) {
        this.deps.Shape.deselectShape();
      }
      this.initScale();
    }
    else if(JSON.stringify(prevProps.participants) != JSON.stringify(this.props.participants)) {
      this.initDefs();
    }
  },
  componentDidMount() {
    this.board = SVG('whiteboard-draw').size(this.drawData.initialWidth, this.drawData.initialHeight);
    this.mainGroup = this.board.group();

    this.initBoardEvents();
    this.initScale();
  },
  render() {
    if(this.props.channel) {
      return (
        <div className={ 'whiteboard-section' + this.expandButtonClass() }>
          <span className="icon-whiteboard-hide-mobile" onClick={ this.expandWhiteboard }></span>
          <img className='whiteboard-title' src='/images/title_whiteboard.png' />
          <img className='whiteboard-expand' src={ this.getExpandButtonImage() } onClick={ this.expandWhiteboard } />

          <svg id='whiteboard-draw' className='inline-board-section'/>
          { this.showToolbar() }
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
