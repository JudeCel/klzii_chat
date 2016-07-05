import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';
import { connect }        from 'react-redux';
import ReactDOM           from 'react-dom';
import PinboardActions    from '../../actions/pinboard';
import Builder            from './builder';

const Pinboard = React.createClass({
  mixins: [Builder],
  changePinboardState() {
    this.setState({ minimized: !this.state.minimized });
  },
  getPinboardStateIcon() {
    if(this.state.minimized) {
      return '/images/icon_whiteboard_expand.png';
    }
    else {
      return '/images/icon_whiteboard_shrink.png';
    }
  },
  removePinboardResource(id) {
    if(confirm('Are you sure you want to remove this?')) {
      const { dispatch, channel } = this.props;
      dispatch(PinboardActions.delete(channel, id));
    }
  },
  scalePinboard(svg) {
    const { minimized, maxWidth, maxHeight } = this.state;
    let whiteboard = ReactDOM.findDOMNode(this);
    let scaleX = minimized ? whiteboard.scrollWidth/maxWidth : 1.0;
    let scaleY = minimized ? whiteboard.scrollHeight/maxHeight : 1.0;
    let group = this.getSvgGroup(svg);

    group.transform(`S${scaleX},${scaleY},0,0`);
    group.attr({ pointerEvents: minimized ? 'none' : 'all' });
  },
  drawPinboard(svg) {
    let data = this.startingData();
    let group = this.getSvgGroup(svg) || svg.group();

    let startX = data.x;
    for(var key in this.props.pinboard) {
      let item = this.props.pinboard[key];
      this.addImageAndFrame(svg, group, data, item);
      this.setNextPositionForPinboard(startX, data, item);
    }
  },
  getSvg() {
    return Snap('#pinboard-svg');
  },
  getSvgGroup(svg) {
    return svg.select('g');
  },
  getInitialState() {
    return { minimized: true, maxWidth: 950, maxHeight: 460 };
  },
  componentDidMount() {
    let svg = this.getSvg();
    this.drawPinboard(svg);
    this.scalePinboard(svg);
  },
  componentDidUpdate(props, state) {
    if(props.pinboard != this.props.pinboard) {
      let svg = this.getSvg();
      svg.clear();
      this.drawPinboard(svg);
      this.scalePinboard(svg);
    }
    else {
      let screenChange = JSON.stringify(props.utilityWindow) != JSON.stringify(this.props.utilityWindow);
      if(state.minimized != this.state.minimized || screenChange) {
        this.scalePinboard(this.getSvg());
      }
    }
  },
  render() {
    const { minimized } = this.state;

    if(this.props.channel) {
      return (
        <div id='pinboard-box' className={ 'pinboard-section' + (minimized ? ' minimized' : ' maximized') }>
          <img className='pinboard-title' src='/images/title_whiteboard.png' />
          <img className='pinboard-expand' src={ this.getPinboardStateIcon() } onClick={ this.changePinboardState } />

          <svg id='pinboard-svg' className='inline-board-section' />
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
    channel: state.sessionTopic.channel,
    pinboard: state.pinboard.items,
    utilityWindow: state.utility.window
  }
};

export default connect(mapStateToProps)(Pinboard);
