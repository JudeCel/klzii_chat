import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import sessionActions       from '../actions/session';
import topicActions         from '../actions/topic';
import Messages             from '../components/messages/messages.js'
import Input                from '../components/messages/input.js'
import Whiteboard           from '../components/whiteboard'
import Facilitator         from '../components/members/facilitator.js'
import Participants         from '../components/members/participants.js'
import TopicSelect          from '../components/topics/select.js'

const ChatView = React.createClass({
  componentWillMount() {
    this.props.dispatch(sessionActions.connectToChannel());
  },
  componentWillReceiveProps(nextProps){
    if (nextProps.sessionReady && !nextProps.topicReady) {
      this.props.dispatch(topicActions.selectCurrent(nextProps.socket, nextProps.topics));
    }
  },
  render() {
    return (
      <div id="chat-app-container" className="col-md-12">

        <div className="info-section"></div>

        <Facilitator/>
        <TopicSelect/>
        <Participants/>

        <Whiteboard
          currentUser={ this.props.currentUser }
          whiteboard={ this.props.whiteboard }
          dispatch={ this.props.dispatch }
          channal={ this.props.topicChannal }
        />

        <Messages/>
        <Input/>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    sessionReady: state.chat.ready,
    topics: state.chat.session.topics,
    whiteboard: state.whiteboard,
    topicChannal: state.topic.channel,
    topicReady: state.topic.ready,
    socket: state.chat.socket,
    currentUser: state.members.currentUser,
  }
};
export default connect(mapStateToProps)(ChatView);
