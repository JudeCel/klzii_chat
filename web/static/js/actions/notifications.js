import Constants from '../constants';

const Actions = {
  showNotification(dispatch, data) {
    dispatch({ type: Constants.SHOW_NOTIFICATION, data: data });
  },
  clearNotification(dispatch) {
    dispatch({ type: Constants.CLEAR_NOTIFICATION });
  }
}

export default Actions;
