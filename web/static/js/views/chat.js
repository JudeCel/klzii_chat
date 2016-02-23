import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import sessionActions       from '../actions/session';
import topicActions         from '../actions/topic';
import CurrentInputActions  from '../actions/currentInput';
import MessagesActions      from '../actions/messages';
import CurrentMember        from '../components/members/current.js'
import Messages             from '../components/messages/messages.js'
import Input                from '../components/messages/input.js'
import Whiteboard           from '../components/whiteboard'

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
      this.props.dispatch(MessagesActions.sendMessage(this.props.topicChannal, this.props.currentInput));
    }
  },
  handleChange(e){
    this.props.dispatch(CurrentInputActions.changeValue(e.target.value));
  },
  render() {
    return (
      <div id="chat-app-container" className="col-md-12">
        <div className="info-section"></div>
        <CurrentMember member={this.props.currentUser}/>
        <div className="members"></div>
        <Whiteboard
          currentUser={ this.props.currentUser }
          whiteboard={ this.props.whiteboard }
          dispatch={ this.props.dispatch }
          channal={ this.props.topicChannal }
        />
        <div className='col-md-3 jumbotron chat-messages pull-right'>
          <Messages
            channal={ this.props.topicChannal }
            dispatch={ this.props.dispatch }
            messages={ this.props.messages }
          />
        </div>
        <Input
          onKeyPress={ this.sendMessage }
          handleChange={ this.handleChange }
          action={ this.props.currentInput.action }
          value={ this.props.currentInput.value }
        />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    messages: state.messages.all,
    currentInput: state.currentInput,
    sessionReady: state.chat.ready,
    whiteboard: state.whiteboard,
    topicReady: state.topic.ready,
    topicChannal: state.topic.channel,
    socket: state.chat.socket,
    currentUser: state.members.currentUser,
    members: state.members.all
  }
};
export default connect(mapStateToProps)(ChatView);
