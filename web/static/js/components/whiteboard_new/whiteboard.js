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
  processInput(event) {
      let touches = event.changedTouches;
      let type = "";
      if (touches) {
        let first = touches[0];
        type = "";
        switch(event.type)
        {
        case "touchstart": type = "mousedown"; break;
        case "touchmove":  type = "mousemove"; break;
        case "touchend":
        case "touchcancel":
        default:
          type = "mouseup";
          break;
        }
        let simulatedEvent = document.createEvent("MouseEvent");
        simulatedEvent.initMouseEvent(type, true, true, window, 1,
                                      first.screenX, first.screenY,
                                      first.clientX, first.clientY, false,
                                      false, false, false, 1, null);

        event.target.dispatchEvent (simulatedEvent);

      }
  },
  initBoardEvents() {
    this.board.on('mousedown', Events.boardMouseDown);
    this.board.on('mouseup', Events.boardMouseUp);
    this.board.on('mousemove', Events.boardMouseMove);
    this.board.on('touchmove', this.processInput);
    this.board.on('touchstart', this.processInput);
    this.board.on('touchend', this.processInput);
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

    let boxSize = "0 0 " + this.drawData.initialWidth + " " + this.drawData.initialHeight;
    this.board.attr({viewBox: boxSize});
    this.initScale();
    this.initBoardEvents();
  },
  render() {
    if(this.props.channel) {
      return (
        <div id='whiteboard-box' className={'whiteboard-section' + this.expandButtonClass() }>
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
