import Constants from '../constants';
import NotificationActions from './notifications';

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
          body: inputState.value,
          emotion: inputState.emotion
        }
      }
    case 'edit':
      return {
        action: "update_message",
        payload: {
          id: inputState.id,
          body: inputState.value,
          emotion: inputState.emotion
        }
      }

    case 'reply':
      return {
        action: "new_message",
        payload: {
          replyId: inputState.replyId,
          body: inputState.value,
          emotion: inputState.emotion
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
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    };
  },
  deleteMessage: (channel, payload) => {
    return dispatch => {
      channel.push('delete_message', payload)
      .receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    };
  },
  readMessage:(channel, messageId) => {
    return dispatch => {
      channel.push('read_message', { id: messageId })
      .receive('ok', (resp) =>{
        if (resp && resp.id == messageId) {
          update_message(dispatch, resp);
        }
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  messageStar: (channel, payload) => {
    return dispatch => {
      channel.push('message_star', payload).receive('ok', (resp) =>{
        update_message(dispatch, resp);
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    };
  },
  thumbsUp: (channel, payload) => {
    return dispatch => {
      channel.push('thumbs_up', payload)
      .receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    };
  }
}


export default Actions;
