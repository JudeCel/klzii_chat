import React                from 'react';
import Message              from './message.js'
import Constants            from '../../constants';
import MessagesActions      from '../../actions/messages';

const Messages =  React.createClass({
  deleteMessage(e){
    this.props.dispatch(MessagesActions.deleteMessage(this.props.channal, e.target.id));
  },
  messageStar(e){
    this.props.dispatch(MessagesActions.messageStar(this.props.channal, e.target.id));
  },
  replayMessage(e){
    this.props.dispatch({type: Constants.SET_INPUT_REPLAY, id: e.target.id});
  },
  editMessage(message){
    return (e)=>{
      this.props.dispatch({type: Constants.SET_INPUT_EDIT, id: message.id, value: message.event.body });
    }
  },
  render() {
    return (
      <div>
        {this.props.messages.map( (message) =>
          <Message
            message={ message }
            deleteMessage={ this.deleteMessage }
            messageStar={ this.messageStar }
            editMessage={ this.editMessage }
            replayMessage={ this.replayMessage }
            key={ message.id }
          />
        )}
      </div>
    );
  }
})
export default Messages;
