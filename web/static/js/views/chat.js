import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Actions              from '../actions/chat';
import CurrentMember        from '../components/members/current.js'
import Messages             from '../components/messages/messages.js'

const ChatView = React.createClass({
  componentWillMount() {
    this.props.dispatch(Actions.connectToChannel());
  },
  componentWillReceiveProps(nextProps){
    if (nextProps.chat.needSetEvents && nextProps.chat.channel) {
      this.props.dispatch(Actions.subscribeToEvents(nextProps.chat.channel));
    }
  },
  sendMessage(e){
    if (e.charCode == 13) {
      let payload ={
        ownerId: this.props.chat.currentUser.id,
        body: e.target.value,
        id: Date.now() / 1000
      }
      e.target.value = "";
      this.props.dispatch(Actions.newEntry(this.props.chat.channel, payload));
    }
  },
  render() {
    return (
      <div id="chat-app-container" className="col-md-12">
        <div className="info-section"></div>
        <CurrentMember member={this.props.chat.currentUser}/>
        <div className="members"></div>
        <div className="whiteboard"></div>
        <div className='col-md-3 jumbotron chat-messages pull-right'>
          <Messages messagesCollection={this.props.chat.messages}/>
        </div>
        <div className="form-group ">
          <input onKeyPress={ this.sendMessage } type="text" className="form-control" placeholder="Message"/>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => (state);
export default connect(mapStateToProps)(ChatView);
