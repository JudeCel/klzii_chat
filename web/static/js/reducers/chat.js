import Constants from '../constants';
const initialState = {
  session: {},
  socket: null,
  currentTopic: null,
  channel: null,
  error: null,
  ready: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SOCKET_EVENTS:
      return { ...state, ready: true };

    case Constants.SET_SESSION_CHANNEL:
      return {  ...state, socket: action.socket, channel: action.channel };

    case Constants.SET_SESSION:
      return {  ...state, session: action.session, ready: true };

    case Constants.SOCKET_CONNECTION_ERROR:
      return { ...state, error: action.error };

    default:
      return state;
  }
}
