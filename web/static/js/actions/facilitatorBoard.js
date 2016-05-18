import Constants from '../constants';

const Actions = {
  saveBoard(channel, dispatch, data) {
    channel.push("board_message", {message: data})
    .receive('ok', (data) => {
      dispatch({ type: Constants.SAVE_FACILITATOR_BOARD });
    }).receive('error', (data) => {
      dispatch({
        type: Constants.NEW_MESSAGE_ERROR,
        error: data.error
      });
    });
  }
}

export default Actions;
