import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Input                from '../messages/input.js';
import Facilitator          from '../members/facilitator.js';
import Participants         from '../members/participants.js';
import Messages             from '../messages/messages.js';
import Console              from '../console/index';
import Pinboard             from '../pinboard/index.js';
import mixins               from '../../mixins';
import Whiteboard           from '../whiteboard/whiteboard';

const Focus = React.createClass({
  mixins:[mixins.validations],
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
      if (this.hasPermission(['pinboard', 'can_display_pinboard'])) {
        return <Pinboard />;
      }else{
        return false
      }
    } else {
      if (this.hasPermission(['whiteboard', 'can_display_whiteboard'])) {
        return <Whiteboard member={ this.props }/>;
      }else{
        return false;
      }
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
    colours: state.chat.session.colours,
    currentUser: state.members.currentUser
  };
};

export default connect(mapStateToProps)(Focus);
