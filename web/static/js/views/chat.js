import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import sessionActions              from '../actions/session';
import topicActions              from '../actions/topic';
import CurrentMember        from '../components/members/current.js'
import Messages             from '../components/messages/messages.js'

const ChatView = React.createClass({
  componentWillMount() {
    this.props.dispatch(sessionActions.connectToChannel());
  },
  componentWillReceiveProps(nextProps){
    if (nextProps.sessionReady && !nextProps.topicReady) {
      let topicId = 1;
      this.props.dispatch(topicActions.connectToTopicChannel(nextProps.socket, topicId));
    }
  },
  sendMessage(e){
    if (e.charCode == 13) {
      let payload ={
        body: e.target.value
      }
      this.props.dispatch(topicActions.newTopicMessage(this.props.topicChannal, payload));
      e.target.value = "";
    }
  },
  render() {
    return (
      <div id="chat-app-container" className="col-md-12">
        <div className="info-section"></div>
        <CurrentMember member={this.props.currentUser}/>
        <div className="members"></div>
        <div className="whiteboard"></div>
        <div className='col-md-3 jumbotron chat-messages pull-right'>
          <Messages messagesCollection={this.props.topicMessages}/>
        </div>
        <div className="form-group ">
          <input onKeyPress={ this.sendMessage } type="text" className="form-control" placeholder="Message"/>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    sessionReady: state.chat.ready,
    topicReady: state.topic.ready,
    topicChannal: state.topic.channel,
    topicMessages: state.topic.messages,
    sessionChannal: state.chat.channel,
    socket: state.chat.socket,
    currentUser: state.members.currentUser,
    members: state.members.all
  }
};
export default connect(mapStateToProps)(ChatView);
