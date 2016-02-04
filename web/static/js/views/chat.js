import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Actions              from '../actions/chat';
import CurrentMember        from '../components/members/current.js'

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
        id: Date.now() / 10000
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
          <ul>
            {this.props.chat.messages.map( message =>
              <li key={message.id}>
                Message: {message.body}
                Owner ID: {message.ownerId}
              </li>
            )}
          </ul>
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
