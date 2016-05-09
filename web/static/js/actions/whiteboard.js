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
  subscribeWhiteboardEvents: (channel, whiteboard) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_WHITEBOARD_EVENTS});
      channel.on("draw", (resp) =>{
        whiteboard.processWhiteboard([resp]);
      });

      channel.on("delete_object", (resp) =>{
        whiteboard.deleteObject(resp.uid);
      });

      channel.on("delete_all", (resp) =>{
        whiteboard.deleteAllObjects(resp);
      });

      channel.on("update_object", (resp) =>{
        whiteboard.processWhiteboard([resp]);
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
  getWhiteboardHistory: (channel, whiteboard) => {
    return dispatch => {
      channel.push('whiteboardHistory')
      .receive('ok', (data)=>{
        dispatch({
          type: Constants.SET_WHITEBOARD_HISTORY,
          objects: data.history
        });
        whiteboard.processWhiteboard(data.history);
      })
      .receive('error', (data) => {
        dispatch({
          type: Constants.SEND_OBJECT_ERROR,
          error: data.error
        });
      });
    };
  },
  deleteObject: (channel, uid) => {
    return dispatch => {
      channel.push('delete_object', {uid: uid})
      .receive('ok', (data)=>{
      })
      .receive('error', (data) => {
        dispatch({
          type: Constants.SEND_OBJECT_ERROR,
          error: data.error
        });
      });
    };
  },
  deleteAll: (channel) => {
    return dispatch => {
      channel.push('deleteAll', {})
      .receive('ok', (data)=>{
      })
      .receive('error', (data) => {
        dispatch({
          type: Constants.SEND_OBJECT_ERROR,
          error: data.error
        });
      });
    };
  },
  updateObject: (channel, object) => {
    return dispatch => {
      channel.push('update_object', {object: object})
      .receive('ok', (data)=>{
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
