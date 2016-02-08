import Constants                          from '../constants';
import { Socket }                         from 'phoenix';

export function joinChannal(dispatch) {
  const socket = new Socket('/socket', {
    params: {
      token: localStorage.getItem("sessionMemberToken")
    },
    // logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); },
  });

  socket.connect();

  const channel = socket.channel(`sessions:${1}`);

  dispatch({
    type: Constants.SET_SESSION_CHANNEL,
    socket: socket,
    channel: channel
  });
  dispatch(Actions.subscribeToSeesionEvents(channel))


  if (channel.state != 'joined') {
    channel.join()
    .receive('ok', (resp) => {
      dispatch({
        type: Constants.SET_SESSION,
        session: resp
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

function currentMember(dispatch, data) {
  return dispatch({
      type: Constants.SET_CURRENT_USER,
      user: data
    });
}

const Actions = {
  connectToChannel: () => {
    return dispatch => {
      return joinChannal(dispatch);
    };
  },
  subscribeToSeesionEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_SESSION_EVENTS});
      channel.on("self_info", (resp) =>{
        return currentMember(dispatch, resp);
      });
    }
  }
}

export default Actions;
