import Constants                          from '../constants';
import { Socket }                         from 'phoenix';

export function joinChannal(dispatch) {
  let localStorageData = JSON.parse(localStorage.getItem("currentSession"));
  const socket = new Socket('/socket', {
    params: {
      token: localStorageData.memberToken,
      sessionId: localStorageData.sessionId
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
      dispatch({
          type: Constants.SOCKET_CONNECTED,
          error: resp
        });
    });
  }
};

const Actions = {
  connectToChannel: () => {
    return dispatch => {
      joinChannal(dispatch);
    };
  },
  connectToChannel: () => {
    return dispatch => {
      joinChannal(dispatch);
    };
  }
}

export default Actions;
