import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Input                from '../messages/input.js';
import Facilitator          from '../members/facilitator.js';
import Messages             from '../messages/messages.js';
import Console              from '../console/index';
import WhiteboardCanvas     from '../whiteboard/whiteboardCanvas';

const Forum = React.createClass({
  mainBlockStyles() {
    const { colours } = this.props;
    return {
      backgroundColor: colours.mainBackground,
      borderColor: colours.mainBorder
    };
  },
  aboutThisTopicHeaderStyles() {
    const { colours } = this.props;
    return {
      backgroundColor: colours.mainBorder
    };
  },
  render() {
    return (
      <div>
        <div className='col-md-3 room-section room-section-left' style={ this.mainBlockStyles() }>
          <div className='aboutThisTopic' style={ this.aboutThisTopicHeaderStyles() }>
            About this Topic
          </div>
          <div className='top-row'>
            <Facilitator />
          </div>
          <Console />
          <div className='top-row'>
            <WhiteboardCanvas member={ this.props }/>
          </div>
        </div>
        <div className='col-md-9 room-section room-section-right' style={ this.mainBlockStyles() }>
          <Messages/>
          <Input/>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    pinboardActive: state.sessionTopicConsole.data.pinboard,
    colours: state.chat.session.colours
  };
};

export default connect(mapStateToProps)(Forum);
