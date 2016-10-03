import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from '../../../constants';
import MessagesActions      from '../../../actions/messages';

const StarMessage = React.createClass({
  starMessage() {
    const { dispatch, channel, message } = this.props;
    dispatch(MessagesActions.messageStar(channel, { id: message.id }));
  },
  setClass() {
    const className = 'icon-star';
    return this.props.message.star ? className : className + '-empty';
  },
  render() {
    const { permission } = this.props;

    if(permission) {
      return(
        <i className={ this.setClass() } onClick={ this.starMessage } />
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

export default connect(mapStateToProps)(StarMessage);
