

import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Input                from '../messages/input.js';
import Facilitator          from '../members/facilitator.js';
import Messages             from '../messages/messages.js';
import Console              from '../console/index';
import Whiteboard           from '../whiteboard/whiteboard';
import mixins               from '../../mixins';

const Forum = React.createClass({
  mixins:[mixins.validations],
  getInitialState: function() {
    const { colours } = this.props;
    return {
      mainBlockStyles: {
        backgroundColor: colours.mainBackground,
        borderColor: colours.mainBorder,
      },
      aboutThisTopicHeaderStyles: {
        backgroundColor: colours.mainBorder
      }
    };
  },
  renderWhiteboard() {
    if (this.hasPermission(['whiteboard', 'can_display_whiteboard'])) {
      return <Whiteboard member={ this.props }/>;
    }else{
      return false;
    }
  },
  render() {
    return (
      <div>
        <div className='col-md-3 room-section room-section-left' style={ this.state.mainBlockStyles }>
          <div className='aboutThisTopic' style={ this.state.aboutThisTopicHeaderStyles }>
            About this Topic
          </div>
          <div id="topicSection" className='top-row'>
            <Facilitator />
          </div>
          <Console />
          <div className='top-row'>
            { this.renderWhiteboard() }
          </div>
        </div>
        <div className='col-md-9 room-section room-section-right' style={ this.state.mainBlockStyles }>
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
    colours: state.chat.session.colours,
    currentUser: state.members.currentUser
  };
};

export default connect(mapStateToProps)(Forum);
