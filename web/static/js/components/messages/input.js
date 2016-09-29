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
  handleChange(e) {
    const { dispatch } = this.props;
    dispatch(InputActions.changeValue(e.target.value));
  },
  onKeyDown(e) {
    if((e.keyCode == 10 || e.keyCode == 13) && (e.ctrlKey || e.metaKey)) {
      this.sendMessage();
    }
  },
  sendMessage() {
    const { topicChannel, currentInput, dispatch } = this.props;
    if(currentInput.value.length > 0) {
      dispatch(MessagesActions.sendMessage(topicChannel, currentInput));
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
    let className = 'form-control' + (currentInput.replyColour ? ' wider-border' : '');

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
  render() {
    const { currentInput, currentUser } = this.props;

    if(this.hasPermission(['messages', 'can_new_message'])) {
      return (
        <div className='input-section'>
          <div className='form-group'>
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
      return (<div className='input-section'></div>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    currentInput: state.currentInput,
    topicChannel: state.sessionTopic.channel
  }
};

export default connect(mapStateToProps)(Input);
