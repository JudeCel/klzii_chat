import React, {PropTypes} from 'react';
import ReactDOM           from 'react-dom';
import { connect }        from 'react-redux';
import Actions            from '../../actions/currentInput';
import MessagesActions    from '../../actions/messages';
import TextareaAutosize   from 'react-autosize-textarea';

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
  componentDidUpdate() {
    let input = ReactDOM.findDOMNode(this).querySelector('#chat-input');
    if(input) {
      input.focus();
    }
  },
  render() {
    const { action, permissions, inputPrefix } = this.props;

    if(permissions && permissions.events.can_new_message) {
      return (
        <div className='input-section'>
          <div className='form-group'>
            <div className='input-group input-group-lg'>
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
    action: state.currentInput.action,
    permissions: state.members.currentUser.permissions,
    currentInput: state.currentInput,
    value: state.currentInput.value,
    topicChannel: state.topic.channel,
    inputPrefix: state.currentInput.inputPrefix,
  }
};

export default connect(mapStateToProps)(Input);
