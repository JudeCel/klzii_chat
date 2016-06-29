import Constants from '../constants';

const Actions = {
  subscribeNotificationsEvents:(channel) => {
    return dispatch => {
      channel.on('show_notification', (data) => {
        return dispatch({ type: Constants.SHOW_NOTIFICATION, data: data });
      });
    }
  },
  showNotification(dispatch, data) {
    dispatch({ type: Constants.SHOW_NOTIFICATION, data: data });
  },
  clearNotification(dispatch) {
    dispatch({ type: Constants.CLEAR_NOTIFICATION });
  }
}

export default Actions;
