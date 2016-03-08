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
import Resources          from '../components/resources/resources.js'

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
    const {error, currentUser, whiteboard, dispatch, topicChannal } = this.props
    if (error) {
      return (<div>{error}</div>)
    }else {
      return (
        <div id="chat-app-container" className="col-md-12">
          <div className="row info-section">
            <TopicSelect/>
            <Resources/>
          </div>
          <Facilitator/>
          <Participants/>
          <Whiteboard/>
          <Messages/>
          <Input/>
        </div>
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    sessionReady: state.chat.ready,
    error: state.chat.error,
    topics: state.chat.session.topics,
    whiteboard: state.whiteboard,
    topicChannal: state.topic.channel,
    topicReady: state.topic.ready,
    socket: state.chat.socket,
    currentUser: state.members.currentUser,
  }
};
export default connect(mapStateToProps)(ChatView);
