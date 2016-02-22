import Constants                          from '../constants';

export function joinChannal(dispatch, socket, topicId) {
  const channel = socket.channel("topics:" + topicId);
  dispatch({
    type: Constants.SET_TOPIC_CHANNEL,
      channel: channel
    });

  dispatch(Actions.subscribeTopicEvents(channel))
  if (channel.state != 'joined') {
    channel.join()
    .receive('ok', (resp) => {
      dispatch({
          type: Constants.SET_TOPIC_HISTORY,
          messages: resp
        });
    })
    .receive('error', (resp) =>{
      return dispatch({
          type: Constants.SOCKET_CONNECTED,
          error: resp
        });
    });
  }
};

function new_message(dispatch, data) {
  return dispatch({
    type: Constants.NEW_TOPIC_MESSAGE,
    message: data
  });
}
function delete_mesage(dispatch, data) {
  return dispatch({
    type: Constants.DELETE_TOPIC_MESSAGE,
    message: data
  });
}
function update_mesage(dispatch, data) {
  return dispatch({
    type: Constants.UPDATE_TOPIC_MESSAGE,
    message: data
  });
}

const Actions = {
  connectToTopicChannel: (socket, topicId) => {
    return dispatch => {
      return joinChannal(dispatch, socket, topicId);
    };
  },
  subscribeTopicEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_TOPIC_EVENTS});
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
  newTopicMessage: (channel, payload) => {
    return dispatch => {
      channel.push('new_message', payload)
      .receive('error', (data) => {
        dispatch({
          type: Constants.NEW_MESSAGE_ERROR,
          error: data.error
        });
      });
    };
  },
  deleteMessage: (channel, id) => {
    return dispatch => {
      channel.push('delete_message', {id: id})
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
