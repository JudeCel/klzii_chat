import React, {PropTypes}  from 'react';
import Actions             from '../actions/sessionTopic';

const headerActions = {
  setSessionTopic(id) {
    const { dispatch, channel, whiteboardChannel } = this.props;
    dispatch(Actions.changeSessionTopic(channel, whiteboardChannel, id));
  },
  setSessionTopicActive(id, active) {
    const { dispatch, channel } = this.props;
    dispatch(Actions.setSessionTopicActive(channel, id, active));
  },
  logOut() {
    if (this.props.currentUser.logout_path) {
      let token = localStorage.getItem("sessionMemberToken");
      let url = this.props.currentUser.logout_path;
      url += (url.split('?')[1] ? '&' : '?') + 'token=' + token;
      window.location.href = url;
    }
  },
  dashboardLogout() {
    window.location.href = this.props.resourcesConf.dashboard_url + "/logout";
  }
};

export default headerActions;
