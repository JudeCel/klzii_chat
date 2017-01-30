import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Input                from '../messages/input.js';
import Facilitator          from '../members/facilitator.js';
import Participants         from '../members/participants.js';
import Messages             from '../messages/messages.js';
import Console              from '../console/index';
import Pinboard             from '../pinboard/index.js';

import Whiteboard           from '../whiteboard/whiteboard';

const Focus = React.createClass({
  getInitialState: function() {
    const { colours } = this.props;
    return {
      mainBlockStyles: {
        backgroundColor: colours.mainBackground,
        borderColor: colours.mainBorder
      },
    };
  },
  renderWhiteboard() {
    if(this.props.pinboardActive) {
      return <Pinboard />;
    } else {
      return <Whiteboard member={ this.props }/>;
    }
  },
  render() {
    return (
      <div className='col-md-12 room-section' style={ this.state.mainBlockStyles }>
        <div className='row'>
          <div className='col-md-8'>
            <div className='row top-row'>
              <Facilitator />
              { this.renderWhiteboard() }
            </div>
            <div className='row'>
              <Console />
            </div>
            <div className='row'>
              <Participants />
            </div>
          </div>
          <div className='col-md-4'>
            <Messages/>
          </div>
          <div className='col-md-12'>
            <Input/>
          </div>
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

export default connect(mapStateToProps)(Focus);
