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

      channel.on("delete_object", (resp) =>{
        dispatch({
          type: Constants.DELETE_WHITEBOARD_SHAPE,
          shape: resp
        });
      });

      channel.on("delete_all", (resp) =>{
        dispatch({
          type: Constants.DELETE_ALL_WHITEBOARD_SHAPES,
        });
      });

      channel.on("update_object", (resp) =>{
        dispatch({
          type: Constants.UPDATE_WHITEBOARD_SHAPE,
          shape: resp
        });
      });
    }
  },
  sendobject: (channel, payload) => {
    return dispatch => {
      channel.push(payload.action, payload)
      .receive('ok', (data)=>{ })
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
      .receive('ok', (data)=>{})
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
      .receive('ok', (data)=>{ console.log(data, 'update_object') })
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
