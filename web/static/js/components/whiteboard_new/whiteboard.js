import React        from 'react';
import { connect }  from 'react-redux';
import SVG          from 'svgjs';
import svgDraw      from 'svg.draw.js';
import svgDrag      from 'svg.draggable.js';
import svgResize    from 'svg.resize.js';
import svgSelect    from 'svg.select.js';

import Events       from './events';
import Shape        from './shape';

const Whiteboard = React.createClass({
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
  componentDidUpdate(prevProps) {
    this.drawData.color = this.props.currentUser.colour;
    console.error(prevProps.shapes != this.props.shapes);
    if(prevProps.shapes != this.props.shapes) {
      this.deps.Shape.loadShapes();
    }
  },
  componentDidMount() {
    this.board = SVG('whiteboard').size('950px', '460px');

    this.mouseData = { type: 'draw', prevType: null, selected: null };
    this.shapeData = { shape: {}, added: {} };
    this.drawData = {
      current: 'scribble',
      color: 'red'
    };

    this.initBoardEvents();
    this.initDependencies();
  },
  render() {
    return (<div id='whiteboard'></div>);
  }
});

const mapStateToProps = (state) => {
  return {
    shapes: state.whiteboard.shapes,
    channel: state.whiteboard.channel,
    currentUser: state.members.currentUser,
    // utilityWindow: state.utility.window
  }
};

export default connect(mapStateToProps)(Whiteboard);
