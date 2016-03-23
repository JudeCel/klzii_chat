import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import sessionActions       from '../actions/session';
import topicActions         from '../actions/topic';
import Messages             from '../components/messages/messages.js';
import Input                from '../components/messages/input.js';
import Whiteboard           from '../components/whiteboard';
import Facilitator          from '../components/members/facilitator.js';
import Participants         from '../components/members/participants.js';
import TopicSelect          from '../components/topics/select.js';
import Resources            from '../components/resources/resources.js';
import HeaderLinks          from '../components/header/links.js';

const ChatView = React.createClass({
  styles() {
    const { colours } = this.props;
    return {
      header: { border: '2px solid red' },
      room: {
        backgroundColor: colours.mainBackground,
        border: '2px solid ' + colours.mainBorder
      }
    };
  },
  componentWillMount() {
    this.props.dispatch(sessionActions.connectToChannel());
  },
  componentWillReceiveProps(nextProps){
    if(nextProps.sessionReady && !nextProps.topicReady) {
      this.props.dispatch(topicActions.selectCurrent(nextProps.socket, nextProps.topics));
    }
  },
  render() {
    const { error } = this.props;

    if(error) {
      return (<div>{error}</div>)
    }
    else {
      return (
        <div id='chat-app-container'>
          <nav className='row header-section'>
            <TopicSelect/>
            <Resources/>
            <HeaderLinks/>
          </nav>

          <div className='col-md-12 room-section' style={ this.styles().room }>
            <Facilitator/>
            <Participants/>
            <Whiteboard/>
            <Messages/>
            <Input/>
          </div>
        </div>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
    sessionReady: state.chat.ready,
    error: state.chat.error,
    topics: state.chat.session.topics,
    topicReady: state.topic.ready,
    socket: state.chat.socket
  };
};

export default connect(mapStateToProps)(ChatView);
