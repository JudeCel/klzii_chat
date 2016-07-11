import Constants from '../constants';
import NotificationActions from './notifications';

const Actions = {
  saveBoard(channel, dispatch, data) {
    channel.push("board_message", {message: data})
    .receive('ok', (data) => {
      dispatch({ type: Constants.SAVE_FACILITATOR_BOARD });
    }).receive('error', (errors) => {
      NotificationActions.showErrorNotification(dispatch, errors);
    });
  }
}

export default Actions;
