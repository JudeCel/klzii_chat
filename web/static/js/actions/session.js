import Constants  from '../constants';
import { Socket } from 'phoenix';

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
    socket,
    channel
  });
  dispatch(Actions.subscribeToSeesionEvents(channel))


  if (channel.state != 'joined') {
    channel.join()
    .receive('ok', (session) => {
      dispatch({
        type: Constants.SET_SESSION,
        session
      });
    })
    .receive('error', (error) =>{
      return dispatch({
          type: Constants.SOCKET_CONNECTED,
          error
        });
    });
  }
};

function currentMember(dispatch, user) {
  return dispatch({
    type: Constants.SET_CURRENT_USER,
    user
  });
}

function members(dispatch, members) {
  return dispatch({
    type: Constants.SET_MEMBERS,
    participant: members.participant,
    observer: members.observer,
    facilitator: members.facilitator
  });
}

const Actions = {
  connectToChannel: () => {
    return dispatch => {
      joinChannal(dispatch);
    };
  },
  subscribeToSeesionEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_SESSION_EVENTS});

      channel.on("self_info", (resp) =>{
        currentMember(dispatch, resp);
      });

      channel.on("members", (resp) =>{
        members(dispatch, resp);
      });
    }
  }
}

export default Actions;