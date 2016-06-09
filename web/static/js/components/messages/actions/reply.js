import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from '../../../constants';

const ReplyMessage = React.createClass({
  replyMessage() {
    const { dispatch, message } = this.props;
    dispatch({ type: Constants.SET_INPUT_REPLY, replyId: message.id });
  },
  render() {
    const { permission } = this.props;

    if(permission) {
      return(
        <i className='icon-reply-empty' onClick={ this.replyMessage } />
      )
    }
    else {
      return(false)
    }
  }
});

const mapStateToProps = (state) => {
  return {};
};

export default connect(mapStateToProps)(ReplyMessage);
