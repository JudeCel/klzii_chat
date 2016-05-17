import React                from 'react';
import ReactDOM             from 'react-dom';
import Message              from './message.js';
import Constants            from '../../constants';
import MessagesActions      from '../../actions/messages';
import { connect }          from 'react-redux';

const Messages =  React.createClass({
  initialState() {
    return {
      previousPosition: 0
    }
  },
  getDataAttrs(e) {
    let id = e.target.getAttribute('data-id');
    let value = e.target.getAttribute('data-body');
    let replyId = e.target.getAttribute('data-replyid');
    return { id, value, replyId };
  },
  deleteMessage(e) {
    let { id, replyId } = this.getDataAttrs(e);
    const { dispatch, channel } = this.props;

    dispatch(MessagesActions.deleteMessage(channel, { id, replyId }));
    dispatch({ type: Constants.SET_INPUT_DEFAULT_STATE });
  },
  thumbsUp(e) {
    let { id } = this.getDataAttrs(e);
    const { dispatch, channel } = this.props;

    dispatch(MessagesActions.thumbsUp(channel, { id }));
    dispatch({ type: Constants.SET_INPUT_DEFAULT_STATE });
  },
  messageStar(e) {
    let { id } = this.getDataAttrs(e);
    const { dispatch, channel } = this.props;

    dispatch(MessagesActions.messageStar(channel, { id }));
  },
  replyMessage(e) {
    let { replyId } = this.getDataAttrs(e);
    this.props.dispatch({ type: Constants.SET_INPUT_REPLY, replyId });
  },
  editMessage(e) {
    let { id, value } = this.getDataAttrs(e);
    this.props.dispatch({ type: Constants.SET_INPUT_EDIT, id, value });
  },
  componentWillUpdate() {
    let chatMessages = ReactDOM.findDOMNode(this);
    let chatBoxHeight = chatMessages.scrollTop + chatMessages.offsetHeight;
    this.shouldScrollBottom = (chatBoxHeight === chatMessages.scrollHeight);
  },
  componentDidUpdate() {
    let chatMessages = ReactDOM.findDOMNode(this);
    let scrollClass = ' add-overflow-y';
    let hasScroll = chatMessages.className.includes(scrollClass);

    if(chatMessages.scrollHeight > chatMessages.offsetHeight) {
      if(!hasScroll) {
        chatMessages.className += scrollClass;
      }
    }
    else {
      if(hasScroll) {
        chatMessages.className = chatMessages.className.replace(scrollClass, '');
      }
    }

    this.scrollToBottomOfChat();
  },
  scrollToBottomOfChat() {
    if(this.shouldScrollBottom) {
      let chatMessages = ReactDOM.findDOMNode(this);
      chatMessages.scrollTop = chatMessages.scrollHeight;
    }
  },
  render() {
    return (
      <div className='chat-section'>
        {
          this.props.messages.map((message) =>
            <Message
              message={ message }
              deleteMessage={ this.deleteMessage }
              messageStar={ this.messageStar }
              editMessage={ this.editMessage }
              replyMessage={ this.replyMessage }
              thumbsUp={ this.thumbsUp }
              isReply={ true }
              key={ message.id }
            />
          )
        }
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    messages: state.messages.all,
    channel: state.sessionTopic.channel
  }
};

export default connect(mapStateToProps)(Messages);
