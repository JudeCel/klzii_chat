import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import TextareaAutosize   from 'react-autosize-textarea';
import DirectMessageActions from '../../../../actions/directMessage';

const MessageInput = React.createClass({
  getInitialState() {
    return { text: '' };
  },
  onChange(e) {
    this.setState({ text: e.target.value });
  },
  onKeyDown(e) {
    if((e.keyCode == 10 || e.keyCode == 13) && (e.ctrlKey || e.metaKey)) {
      this.sendMessage();
    }
  },
  sendMessage() {
    const { text } = this.state;

    if(text.length > 0) {
      const { dispatch, channel, currentRecieverId } = this.props;
      dispatch(DirectMessageActions.send(channel, { recieverId: currentRecieverId, text: text }));
      this.setState(this.getInitialState());
    }
  },
  render() {
    return (
      <div className='input-section form-group'>
        <div className='input-group input-group-lg'>
          <TextareaAutosize type='text' className='form-control no-border-radius' placeholder='Message'
            onChange={ this.onChange }
            onKeyDown={ this.onKeyDown }
            value={ this.state.text }
          />
          <div className='input-group-addon no-border-radius cursor-pointer' onClick={ this.sendMessage }>POST</div>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.chat.channel,
    currentRecieverId: state.directMessages.currentReciever
  }
};

export default connect(mapStateToProps)(MessageInput);
