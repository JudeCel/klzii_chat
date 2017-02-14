import { Socket } from 'phoenix';

export function joinChannal(dispatch) {
  const socket = new Socket('/admin', {
    // logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); },
  });

  const channel = socket.channel(`logs:pull`);
  if (channel.state != 'joined') {
    dispatch({
      type: 'SET_LOGS_CHANNEL',
      socket,
      channel
    });
    dispatch(Actions.subscribeToLogsEvents(channel));

    channel.join()
    .receive('ok', (resp) => {
      dispatch({
        type: 'SET_LOGS_DATA',
        resp
      });
    })
    .receive('error', (error) =>{
      dispatch({
        type: 'SOCKET_CONNECTION_ERROR',
        error
      });
    });
  }

  let whenConnectionCrash = (event) =>{
    dispatch({
      type: Constants.SOCKET_CONNECTION_ERROR,
      error: "Connection error, reconnecting"
    });
  }

  socket.onError( (event) => {
    whenConnectionCrash(event);
  });

  socket.connect();
};

const Actions = {
  connectToChannel: () => {
    return dispatch => {
      joinChannal(dispatch);
    };
  },
  subscribeToLogsEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: 'SET_LOGS_EVENTS'});
      channel.on("new_log_entry", (resp) =>{
        dispatch({
          type: 'NEW_LOG_ENTRY',
          entry: resp
        });
      });
    }
  },
  change_filter: (channel, payload) => {
    return dispatch => {
      channel.push("change_filter", payload).receive('ok', (resp) =>{
        dispatch({
          type: 'SET_LOGS_DATA',
          resp
        });
      }).receive('error', (errors) => {
      });
    };
  },
}
export default Actions;
