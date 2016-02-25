import React                from 'react';
import Message              from './message.js'
import Constants            from '../../constants';
import MessagesActions      from '../../actions/messages';

const Messages =  React.createClass({
  getDataAttrs(e){
    let id = e.target.getAttribute('data-id');
    let value = e.target.getAttribute('data-body');
    let replyId = e.target.getAttribute('data-replyid');
    return { id, value, replyId };
  },
  deleteMessage(e){
    let { id, replyId} = this.getDataAttrs(e);
    this.props.dispatch(MessagesActions.deleteMessage(this.props.channal, { id, replyId }));
    this.props.dispatch({type: Constants.SET_INPUT_DEFAULT_STATE });
  },
  thumbsUp(e){
    let { id } = this.getDataAttrs(e);
    this.props.dispatch(MessagesActions.thumbsUp(this.props.channal, { id }));
    this.props.dispatch({type: Constants.SET_INPUT_DEFAULT_STATE });
  },
  messageStar(e){
    let { id } = this.getDataAttrs(e);
    this.props.dispatch(MessagesActions.messageStar(this.props.channal, { id }));
  },
  replyMessage(e){
    let { replyId } = this.getDataAttrs(e);
    this.props.dispatch({type: Constants.SET_INPUT_REPLY, replyId});
  },
  editMessage(e){
    let { id, value } = this.getDataAttrs(e);
    this.props.dispatch({type: Constants.SET_INPUT_EDIT, id, value });
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
            thumbsUp={ this.thumbsUp }
            key={ message.id }
          />
        )}
      </div>
    );
  }
})
export default Messages;
