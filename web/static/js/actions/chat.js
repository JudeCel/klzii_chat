import Constants                          from '../constants';
import { Socket }                         from 'phoenix';

export function joinChannal(dispatch) {
  const socket = new Socket('/socket', {
    params: {
      token: localStorage.getItem("sessionMemberToken")
    },
    logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); },
  });

  socket.connect();
  const channel = socket.channel(`sessions:${1}`);

  if (channel.state != 'joined') {
    channel.join()
    .receive('ok', (resp) => {
      dispatch({
          type: Constants.SOCKET_CONNECTED,
          socket: socket,
          channel: channel,
          currentUser: resp
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

function newEntry(dispatch, data) {
  return dispatch({
      type: Constants.NEW_MESSAGE,
      message: data
    });
}

const Actions = {
  connectToChannel: () => {
    return dispatch => {
      dispatch({ type: Constants.SOCKET_CONNECTION_FETCHING});
      return joinChannal(dispatch);
    };
  },
  subscribeToEvents: (channel) =>{
    return dispatch => {
      channel.on("new_message", (resp) =>{
        return newEntry(dispatch, resp);
      });
    }
  },

  newEntry: (channel, payload) => {
    return dispatch => {
      channel.push('new_message', payload)
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
