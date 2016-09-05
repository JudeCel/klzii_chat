import Constants from '../constants';
import NotificationActions from './notifications';

const Actions = {
  saveBoard(channel, dispatch, data) {
    dispatch({ type: Constants.MODAL_POST_DATA });
    channel.push("board_message", {message: data})
    .receive('ok', (data) => {
      dispatch({ type: Constants.SAVE_FACILITATOR_BOARD });
      dispatch({ type: Constants.MODAL_POST_DATA_DONE_AND_CLOSE });
    }).receive('error', (errors) => {
      dispatch({ type: Constants.MODAL_POST_DATA_DONE });
      NotificationActions.showErrorNotification(dispatch, errors);
    });
  },
  saveClose(dispatch) {
    dispatch({ type: Constants.CLOSE_ALL_MODAL_WINDOWS });
  }
}

export default Actions;
