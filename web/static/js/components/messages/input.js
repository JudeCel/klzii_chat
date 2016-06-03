import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Actions            from '../../actions/currentInput';
import MessagesActions    from '../../actions/messages';
import TextareaAutosize   from 'react-autosize-textarea';
import EmotionPicker      from './emotionPicker';

const Input = React.createClass({
  handleChange(e) {
    const { dispatch } = this.props;
    dispatch(Actions.changeValue(e.target.value));
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
  defaultProps() {
    const { value } = this.props;
    return {
      onKeyDown: this.onKeyDown,
      value: value,
      type: 'text',
      onChange: this.handleChange,
      className: 'form-control',
      placeholder: 'Message',
      id: 'chat-input',
    };
  },
  render() {
    const { permissions, inputPrefix } = this.props;

    if(permissions && permissions.events.can_new_message) {
      return (
        <div className='input-section'>
          <div className='form-group'>
            <div className='input-group input-group-lg'>
              <div className='input-group-addon no-border-radius emotion-picker-section'><EmotionPicker /></div>
              <div className='input-group-addon no-border-radius'>{ inputPrefix }</div>
              <TextareaAutosize { ...this.defaultProps() } />
              <div className='input-group-addon no-border-radius cursor-pointer' onClick={ this.sendMessage }>POST</div>
            </div>
          </div>
        </div>
      )
    }
    else {
      return (<div></div>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    value: state.currentInput.value,
    inputPrefix: state.currentInput.inputPrefix,
    permissions: state.members.currentUser.permissions,
    currentInput: state.currentInput,
    topicChannel: state.sessionTopic.channel
  }
};

export default connect(mapStateToProps)(Input);
