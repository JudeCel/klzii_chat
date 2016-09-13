import React, {PropTypes}  from 'react';
import Actions             from '../actions/sessionTopic';

const headerActions = {
  setSessionTopic(id) {
    const { dispatch, channel, whiteboardChannel } = this.props;
    dispatch(Actions.changeSessionTopic(channel, whiteboardChannel, id));
  },
  logOut() {
    if (this.props.currentUser.logout_path) {
      window.location.href = this.props.currentUser.logout_path;
    }
  }
};

export default headerActions;
