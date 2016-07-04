import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';

const Pinboard = React.createClass({
  // mixins: [mixins.modalWindows, mixins.validations, mixins.helpers],
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
  getInitialState() {
    return { minimized: true };
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
  }
};

export default connect(mapStateToProps)(Pinboard);
