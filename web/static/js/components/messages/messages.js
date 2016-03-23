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
    const OFFSET = 4;
    let chatMessages = ReactDOM.findDOMNode(this);
    this.shouldScrollBottom = chatMessages.scrollTop + chatMessages.offsetHeight === chatMessages.scrollHeight + OFFSET;
  },
  componentDidUpdate() {
    this.scrollToBottomOfChat();
  },
  scrollToBottomOfChat() {
    let chatMessages = ReactDOM.findDOMNode(this);

    if(this.shouldScrollBottom) {
      chatMessages.scrollTop = chatMessages.scrollHeight;
    }
  },
  render() {
    return (
      <div className='col-md-4 chat-section'>
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
    channel: state.topic.channel
  }
};

export default connect(mapStateToProps)(Messages);
