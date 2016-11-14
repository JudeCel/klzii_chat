import Constants  from '../constants';
import NotificationActions from './notifications';

function update_message(dispatch, data) {
  return dispatch({
    type: Constants.UPDATE_TOPIC_MESSAGE,
    message: data
  });
}

const Actions = {
  updateAvatar: (channel, payload) => {
    return dispatch => {
      channel.push('update_member', payload)
      .receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    };
  },
  stopAnimation: (member) => {
    return dispatch => {
      dispatch({
        type: Constants.NEW_MESSAGE_ANIMATION_STOP,
        member: member
      });
    };
  }
}


export default Actions;
