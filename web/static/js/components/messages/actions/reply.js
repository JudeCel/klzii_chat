import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from '../../../constants';
import ReactDOM                 from 'react-dom';

const ReplyMessage = React.createClass({
  replyMessage() {
    window.scrollTo(0, window.innerHeight * window.innerHeight)
    dispatch({ type: Constants.SET_INPUT_REPLY, replyId: message.id, replyColour: message.session_member.colour });
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
