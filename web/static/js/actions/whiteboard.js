import Constants                          from '../constants';
function new_whiteboard_object(dispatch, data) {
  return dispatch({
      type: Constants.NEW_WHITEBOARD_OBJECT,
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
      dispatch({ type: Constants.SET_WHITEBOARD_EVENTS});
      channel.on("objects", (resp) =>{
        return new_whiteboard_object(dispatch, resp);
      });
    }
  },
  sendobject: (channel, payload) => {
    return dispatch => {
      channel.push('sendobject', payload)
      .receive('error', (data) => {
        dispatch({
          type: Constants.SEND_OBJECT_ERROR,
          error: data.error
        });
      });
    };
  }
}


export default Actions;
