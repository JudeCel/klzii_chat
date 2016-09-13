import React, {PropTypes}  from 'react';
import Actions             from '../actions/sessionTopic';

const sessionTopic = {
  setSessionTopic(id) {
    const { dispatch, channel, whiteboardChannel } = this.props;
    dispatch(Actions.changeSessionTopic(channel, whiteboardChannel, id));
  }
};

export default sessionTopic;
