import Constants  from '../constants';

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
      .receive('error', (data) => {
        dispatch({
          type: Constants.NEW_MESSAGE_ERROR,
          error: data.error
        });
      });
    };
  }
}


export default Actions;
