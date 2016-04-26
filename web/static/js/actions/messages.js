import Constants                          from '../constants';
function new_message(dispatch, data) {
  return dispatch({
    type: Constants.NEW_MESSAGE,
    message: data
  });
}
function delete_message(dispatch, data) {
  return dispatch({
    type: Constants.DELETE_MESSAGE,
    message: data
  });
}
function update_message(dispatch, message) {
  return dispatch({
    type: Constants.UPDATE_MESSAGE,
    message
  });
}

function selectMessageAction(inputState) {
  switch (inputState.action) {
    case 'new':
      return {
        action: "new_message",
        payload: {
          body: inputState.value
        }
      }
    case 'edit':
      return {
        action: "update_message",
        payload: {
          id: inputState.id,
          body: inputState.value
        }
      }

    case 'reply':
      return {
        action: "new_message",
        payload: {
          replyId: inputState.replyId,
          body: inputState.value
        }
      }
    default:

  }
}

const Actions = {
  subscribeMessageEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_MESSAGES_EVENTS});
      channel.on("new_message", (resp) =>{
        return new_message(dispatch, resp);
      });

      channel.on("delete_message", (resp) =>{
        return delete_message(dispatch, resp);
      });

      channel.on("update_message", (resp) =>{
        return update_message(dispatch, resp);
      });
    }
  },
  sendMessage: (channel, inputState) => {
    let messageAction = selectMessageAction(inputState)
    return dispatch => {
      channel.push(messageAction.action, messageAction.payload).receive('ok', (_resp) =>{
        dispatch({
          type: Constants.SET_INPUT_DEFAULT_STATE
        });
      })
      .receive('error', (data) => {
        dispatch({
          type: Constants.NEW_MESSAGE_ERROR,
          error: data.error
        });
      });
    };
  },
  deleteMessage: (channel, payload) => {
    return dispatch => {
      channel.push('delete_message', payload)
      .receive('error', (data) => {
        dispatch({
          type: Constants.NEW_MESSAGE_ERROR,
          error: data.error
        });
      });
    };
  },
  messageStar: (channel, payload) => {
    return dispatch => {
      channel.push('message_star', payload).receive('ok', (resp) =>{
        update_message(dispatch, resp);
      })
      .receive('error', (data) => {
        dispatch({
          type: Constants.NEW_MESSAGE_ERROR,
          error: data.error
        });
      });
    };
  },
  thumbsUp: (channel, payload) => {
    return dispatch => {
      channel.push('thumbs_up', payload)
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
