import Constants                          from '../constants';
export function joinChannal(dispatch, socket, sessionTopicId) {
  const channel = socket.channel("whiteboard:" + sessionTopicId);

  if (channel.state != 'joined') {
    dispatch({
      type: Constants.SET_WHITEBOARD_CHANNEL,
      channel
    });
    dispatch(Actions.subscribeEvents(channel))

    channel.join()
    .receive('ok', (resp) => {
      dispatch({
        type: Constants.SET_WHITEBOARD_HISTORY,
        objects: resp
      });
    })
    .receive('error', (resp) =>{
      return dispatch({
        type: Constants.SOCKET_CONNECTION_ERROR,
        error: "Channel ERROR!!!"
      });
    });
  }
};

const Actions = {
  connectToChannel: (socket, sessionTopicId) => {
    return dispatch => {
      return joinChannal(dispatch, socket, sessionTopicId);
    };
  },
  subscribeEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_WHITEBOARD_EVENTS});
      channel.on("draw", (resp) =>{
        dispatch({
          type: Constants.SET_WHITEBOARD_SHAPE,
          shape: resp
        });
      });

      channel.on("delete", (resp) =>{
        dispatch({
          type: Constants.DELETE_WHITEBOARD_SHAPE,
          shape: resp
        });
      });

      channel.on("deleteAll", (resp) =>{
        dispatch({
          type: Constants.DELETE_ALL_WHITEBOARD_SHAPES
        });
      });

      channel.on("update", (resp) =>{
        dispatch({
          type: Constants.UPDATE_WHITEBOARD_SHAPE,
          shape: resp
        });
      });
    }
  },
  create: (channel, payload) => {
    return dispatch => {
      channel.push("draw", payload)
      .receive('ok', (data)=>{ })
      .receive('error', (data) => {
        dispatch({
          type: Constants.SEND_OBJECT_ERROR,
          error: data.error
        });
      });
    };
  },
  delete: (channel, uid) => {
    return dispatch => {
      channel.push('delete', {uid})
      .receive('ok', (data)=>{})
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
      channel.push('deleteAll')
      .receive('ok', (data)=>{})
      .receive('error', (data) => {
        dispatch({
          type: Constants.SEND_OBJECT_ERROR,
          error: data.error
        });
      });
    };
  },
  update: (channel, object) => {
    return dispatch => {
      channel.push('update', {object: object})
      .receive('ok', (data)=>{ })
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
