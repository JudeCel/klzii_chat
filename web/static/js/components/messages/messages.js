import React                from 'react';
import Message              from './message.js'
import Constants            from '../../constants';
import MessagesActions      from '../../actions/messages';

const Messages =  React.createClass({
  getDataAttrs(e){
    let id = e.target.getAttribute('data-id');
    let body = e.target.getAttribute('data-body');
    let replyId = e.target.getAttribute('data-replyid');
    return { id, body, replyId };
  },
  deleteMessage(e){
    let { id, replyId} = this.getDataAttrs(e);
    this.props.dispatch(MessagesActions.deleteMessage(this.props.channal, {id: id, replyId: replyId }));
    this.props.dispatch({type: Constants.SET_INPUT_DEFAULT_STATE });
  },
  messageStar(e){
    let { id } = this.getDataAttrs(e);
    this.props.dispatch(MessagesActions.messageStar(this.props.channal, id));
  },
  replyMessage(e){
    let { replyId } = this.getDataAttrs(e);
    this.props.dispatch({type: Constants.SET_INPUT_REPLY, replyId: replyId});
  },
  editMessage(e){
    let { id, body } = this.getDataAttrs(e);
    this.props.dispatch({type: Constants.SET_INPUT_EDIT, id: id, value: body });
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
            replyMessage={ this.replyMessage }
            key={ message.id }
          />
        )}
      </div>
    );
  }
})
export default Messages;
