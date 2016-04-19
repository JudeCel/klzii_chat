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
        if (window.buildWhiteboard) {
          window.buildWhiteboard.processWhiteboard([resp]);
        }

        if (whiteboard) {
          whiteboard.processWhiteboard([resp]);
        }

      });

      channel.on("delete_object", (resp) =>{
        console.log("Events 2");
        if (window.whiteboard) {
          window.whiteboard.paint.deleteObject(resp.uid);
        }

        if (whiteboard) {
          whiteboard.deleteObject(resp.uid);
        }
      });

      channel.on("delete_all", (resp) =>{
        console.log("Events 3");
        if (window.clearWhiteboard) {
          window.clearWhiteboard();
        }

        if (whiteboard) {
          whiteboard.deleteAllObjects(resp);
        }
      });

      channel.on("update_object", (resp) =>{
        console.log("Events 4");
        if (window.buildWhiteboard) {
          window.buildWhiteboard.processWhiteboard([resp]);
        }

        if (whiteboard) {
          whiteboard.processWhiteboard([resp]);
        }
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
        if (window.buildWhiteboard){
          window.buildWhiteboard.processWhiteboard(data.history);
        }

        if (whiteboard) {
          whiteboard.processWhiteboard(data.history);
        }
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
        console.log("data_", data);
      })
      .receive('error', (data) => {
        console.log("data_error", data);
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
        console.log(data);
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
