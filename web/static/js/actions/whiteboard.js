import Constants                          from '../constants';
function whiteboardHistory(dispatch, data) {
  dispatch({
    type: Constants.SET_WHITEBOARD_READY_TO_BUILD,
    objects: data
  });
}

const Actions = {
  connectToTopicChannel: (socket, topicId) => {
    return dispatch => {
      return joinChannal(dispatch, socket, topicId);
    };
  },
  setWhiteboardBuilt: (socket, topicId) => {
    return dispatch => {
      dispatch({type: Constants.SET_WHITEBOARD_BUILT})
    };
  },
  subscribeWhiteboardEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_WHITEBOARD_EVENTS});
      channel.on("draw", (resp) =>{
        console.log("draw");
        console.log(resp);
        window.buildWhiteboard.processWhiteboard([resp]);
      });
    }
  },
  sendobject: (channel, payload) => {
    return dispatch => {
      channel.push(payload.action, payload)
      .receive('error', (data) => {
        dispatch({
          type: Constants.SEND_OBJECT_ERROR,
          error: data.error
        });
      });
    };
  },
  getWhiteboardHistory: (channel) => {
    return dispatch => {
      channel.push('whiteboardHistory')
      .receive('ok', (data)=>{
        dispatch({
          type: Constants.SET_WHITEBOARD_HISTORY,
          objects: data.history
        });
        console.log(data.history);
        window.buildWhiteboard.processWhiteboard(data.history);
      })
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
