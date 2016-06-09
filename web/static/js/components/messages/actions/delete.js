import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from '../../../constants';
import MessagesActions      from '../../../actions/messages';

const DeleteMessage = React.createClass({
  deleteMessage() {
    const { message, dispatch, channel } = this.props;

    dispatch(MessagesActions.deleteMessage(channel, { id: message.id, replyId: message.replyId }));
    dispatch({ type: Constants.SET_INPUT_DEFAULT_STATE });
  },
  render() {
    const { permission } = this.props;

    if(permission) {
      return(
        <i className='icon-cancel-empty' onClick={ this.deleteMessage } />
      )
    }
    else {
      return(false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.sessionTopic.channel
  };
};

export default connect(mapStateToProps)(DeleteMessage);
