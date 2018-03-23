import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import TextareaAutosize   from 'react-autosize-textarea';
import ReactDOM           from 'react-dom';
import EmotionPicker      from './emotionPicker';
import InputActions       from '../../actions/currentInput';
import MessagesActions    from '../../actions/messages';
import mixins             from '../../mixins';
import Avatar             from '../members/avatar.js';

const Input = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  getInitialState() {
    return { typingTimer: null };
  },
  handleChange(e) {
    const { dispatch, topicChannel } = this.props;

    dispatch(InputActions.changeValue(e.target.value));

    if (this.state.typingTimer == null) {
      dispatch(MessagesActions.typingMessage(topicChannel, true));
    } else {
      clearTimeout(this.state.typingTimer);
    }
    this.state.typingTimer = setTimeout(this.finishTyping, 3000);
  },
  onKeyDown(e) {
    if((e.keyCode == 10 || e.keyCode == 13) && (e.ctrlKey || e.metaKey)) {
      this.sendMessage();
    }
  },
  finishTyping() {
    const { topicChannel, dispatch } = this.props;
    this.state.typingTimer = null;
    dispatch(MessagesActions.typingMessage(topicChannel, false));
  },
  sendMessage() {
    const { topicChannel, currentInput, dispatch } = this.props;
    if(currentInput.value.length > 0) {
      dispatch(MessagesActions.sendMessage(topicChannel, currentInput));
      clearTimeout(this.state.typingTimer);
      this.finishTyping();
    }
  },
  changeAvatar() {
    const { currentUser } = this.props;
    if (currentUser.role != "observer") {
      this.openSpecificModal('avatar');
    }
  },
  defaultProps() {
    const { currentInput } = this.props;
    let style = currentInput.replyColour ? { borderColor: currentInput.replyColour } : undefined;
    let className = 'form-control' + (currentInput.replyColour ? ' wider-border' : '') + (currentInput.smallFont ? " smallFont" : "");

    return {
      onKeyDown: this.onKeyDown,
      value: currentInput.value,
      type: 'text',
      onChange: this.handleChange,
      style: style,
      className: className,
      placeholder: 'Message',
      id: 'chat-input',
    };
  },
  componentDidUpdate(props) {
    if(this.props.currentInput.replyId != props.currentInput.replyId) {
      let input = ReactDOM.findDOMNode(this).querySelector('#chat-input');
      input.focus();
    }
  },
  somebodyTyping(){
    const { sessionTopics, currentUser } = this.props;
    for(var i in sessionTopics.all) {
      if(sessionTopics.all[i].id == sessionTopics.current.id) {
        let typingMembers = sessionTopics.all[i].typingMembers;
        if (typingMembers && (typingMembers.length > 1 || typingMembers.length == 1 && currentUser.id != typingMembers[0])) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  },
  typingBlock() {
    if (this.somebodyTyping()) {
      return (
        <div className='typing-info'>Someone else is posting a comment</div>
      )
    } else {
      return false;
    }
  },
  render() {
    const { currentInput, currentUser } = this.props;

    if(this.hasPermission(['messages', 'can_new_message'])) {
      return (
        <div className='input-section'>
          <div className='form-group'>
            { this.typingBlock() }
            <div className='input-group input-group-lg'>
              <div className='input-group-addon no-border-radius emotion-picker-section'><EmotionPicker /></div>
              <TextareaAutosize { ...this.defaultProps() } />
              <div className='input-group-addon no-border-radius cursor-pointer' onClick={ this.sendMessage }>POST</div>
              <div className='input-group-addon no-border-radius avatar-section'>
                <span onClick={this.changeAvatar}>
                  <Avatar member={ { id: currentUser.id, username: currentUser.username, colour: currentUser.colour, avatarData: currentUser.avatarData, online: true, edit: false } } specificId={ 'message-avatar' } />
                </span>
              </div>
            </div>
          </div>
        </div>
      )
    }
    else {
      return false;
    }
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    currentInput: state.currentInput,
    topicChannel: state.sessionTopic.channel,
    sessionTopics: state.sessionTopic
  }
};

export default connect(mapStateToProps)(Input);
