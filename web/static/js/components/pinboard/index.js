import React, {PropTypes} from 'react';
import SVG                from 'svgjs';
import { connect }        from 'react-redux';
import ReactDOM           from 'react-dom';
import PinboardActions    from '../../actions/pinboard';
import Builder            from './builder';
import mobileScreenHelpers from '../../mixins/mobileHelpers';

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
  scalePinboard() {
    const { minimized, maxWidth } = this.state;
    let whiteboard = ReactDOM.findDOMNode(this);
    this.getSvgGroup();
    this.group.attr({ pointerEvents: minimized ? 'none' : 'all' });
  },
  drawPinboard(svg) {
    let data = this.startingData();
    let startX = data.x;
    for(var key in this.props.pinboard) {
      let item = this.props.pinboard[key];
      this.addImageAndFrame(svg, this.group, data, item);
      this.setNextPositionForPinboard(startX, data, item);
    }
  },
  getSvg() {
    return SVG('pinboard-svg');
  },
  getSvgGroup() {
    if (!this.group) {
      this.group = this.svg.group();
    }
    return this.group;
  },
  getInitialState() {
    return { minimized: true, maxWidth: 950 };
  },
  redrawFrames() {
    this.svg = this.getSvg();
    this.svg.clear();
    this.group = null;
    this.getSvgGroup();
    this.drawPinboard();
    this.scalePinboard();
  },
  componentDidUpdate(props, state) {
    if(props.pinboard != this.props.pinboard) {
      this.redrawFrames();
    }
    else {
      let screenChange = JSON.stringify(props.utilityWindow) != JSON.stringify(this.props.utilityWindow);
      if(state.minimized != this.state.minimized || screenChange) {
        if (mobileScreenHelpers.isMobile()) {
          this.redrawFrames();
        } else {
          this.scalePinboard();
        }
      }
    }
  },
  render() {
    const { minimized } = this.state;

    if(this.props.channel) {
      return (
        <div id='pinboard-box' className={ 'pinboard-section' + (minimized ? ' minimized' : ' maximized') }>
          <span className="icon-pinboard-hide-mobile" onClick={ this.changePinboardState }></span>
          <img className='pinboard-title' src='/images/title_whiteboard.png' />
          <img className='pinboard-expand' src={ this.getPinboardStateIcon() } onClick={ this.changePinboardState } />

          <svg id='pinboard-svg' className='inline-board-section' viewBox="0 0 925 465"/>
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
