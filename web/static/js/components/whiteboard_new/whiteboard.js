import React        from 'react';
import { connect }  from 'react-redux';
import SVG          from 'svgjs';
import svgDraw      from 'svg.draw.js';
import svgDrag      from 'svg.draggable.js';
import svgResize    from 'svg.resize.js';
import svgSelect    from 'svg.select.js';

import Events       from './events';
import Shape        from './shape';
import Design       from './design';
import Toolbar      from './toolbar';
import Elements     from './elements';
import History      from './history';
import Actions      from './actions';

const Whiteboard = React.createClass({
  mixins:[Design],
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
    let scaleX = minimized ? parent.scrollWidth/this.drawData.initialWidth : 1.0;
    let scaleY = minimized ? parent.scrollHeight/this.drawData.initialHeight : 1.0;
    this.board.scale(scaleX, scaleY).translate(0, 0);
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
  },
  initBoardEvents() {
    this.board.mousedown(Events.boardMouseDown);
    this.board.mousemove(Events.boardMouseMove);
    this.board.mouseup(Events.boardMouseUp);
  },
  getInitialState() {
    this.mouseData = { type: 'select', prevType: null, selected: null };
    this.shapeData = { shape: {}, added: {} };
    this.drawData = {
      initialWidth: 950,
      initialHeight: 460,
      strokeWidth: 2,
      current: 'none',
      color: 'red'
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

    this.initBoardEvents();
    this.initScale();
  },
  render() {
    if(this.props.channel) {
      return (
        <div className={ 'whiteboard-section' + this.expandButtonClass() }>
          <img className='whiteboard-title' src='/images/title_whiteboard.png' />
          <img className='whiteboard-expand' src={ this.getExpandButtonImage() } onClick={ this.expandWhiteboard } />

          <svg id='whiteboard-draw' className='inline-board-section'/>
          <Toolbar.Buttons />
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
