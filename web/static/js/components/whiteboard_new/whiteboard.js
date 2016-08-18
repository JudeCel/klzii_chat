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

const Whiteboard = React.createClass({
  mixins:[Design],
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
  },
  initBoardEvents() {
    this.board.mousedown(Events.boardMouseDown);
    this.board.mousemove(Events.boardMouseMove);
    this.board.mouseup(Events.boardMouseUp);
  },
  getInitialState() {
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
  },
  componentDidMount() {
    this.mouseData = { type: 'draw', prevType: null, selected: null };
    this.shapeData = { shape: {}, added: {} };
    this.drawData = {
      initialWidth: 950,
      initialHeight: 460,
      current: 'rect',
      color: 'red'
    };

    this.board = SVG('whiteboard').size(this.drawData.initialWidth, this.drawData.initialHeight).addClass('inline-board-section');

    this.initBoardEvents();
    this.initDependencies();
    this.initScale();
  },
  render() {
    if(this.props.channel) {
      return (
        <div id='whiteboard' className={ 'whiteboard-section' + this.expandButtonClass() }>
          <img className='whiteboard-title' src='/images/title_whiteboard.png' />
          <img className='whiteboard-expand' src={ this.getExpandButtonImage() } onClick={ this.expandWhiteboard } />
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
    utilityWindow: state.utility.window
  }
};

export default connect(mapStateToProps)(Whiteboard);
