import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from '../../../constants';
import MessagesActions      from '../../../actions/messages';

const RateMessage = React.createClass({
  rateMessage() {
    const { dispatch, channel, message } = this.props;
    dispatch(MessagesActions.thumbsUp(channel, { id: message.id }));
  },
  setClass() {
    const className = 'icon-thumbs-up';
    return this.props.message.has_voted ? className + ' active' : className;
  },
  render() {
    const { message, permission } = this.props;

    if(permission) {
      return(
        <i className={ this.setClass() } onClick={ this.rateMessage } >
          <small>{ message.votes_count }</small>
        </i>
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

export default connect(mapStateToProps)(RateMessage);
