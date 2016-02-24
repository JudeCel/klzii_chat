import Constants                          from '../constants';
function new_message(dispatch, data) {
  return dispatch({
    type: Constants.NEW_MESSAGE,
    message: data
  });
}
function delete_mesage(dispatch, data) {
  return dispatch({
    type: Constants.DELETE_MESSAGE,
    message: data
  });
}
function update_mesage(dispatch, data) {
  return dispatch({
    type: Constants.UPDATE_MESSAGE,
    message: data
  });
}

function selectMesageAction(inputState) {
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
          body: inputState.value}
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
        return delete_mesage(dispatch, resp);
      });

      channel.on("message_star", (resp) =>{
        return update_mesage(dispatch, resp);
      });
    }
  },
  sendMessage: (channel, inputState) => {
    let messageAction = selectMesageAction(inputState)
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
  messageStar: (channel, id) => {
    return dispatch => {
      channel.push('message_star', {id: id})
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
