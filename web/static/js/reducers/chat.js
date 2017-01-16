import Constants from '../constants';
const initialState = {
  session: { colours: {} },
  socket: null,
  channel: null,
  error: null,
  ready: false,
  jwtToken: null,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SOCKET_EVENTS:
      return { ...state, ready: true };
    case Constants.SET_JWT_TOKEN:
      return { ...state, jwtToken: action.token };
    case Constants.SET_SESSION_CHANNEL:
      return {  ...state, socket: action.socket, channel: action.channel };

    case Constants.SET_SESSION:
      return {  ...state, session: action.session, ready: true, error: null };
    case Constants.UPDATE_SESSION:
      return {  ...state, session: action.session};
    case Constants.SOCKET_CONNECTION_ERROR:
      return { ...state, error: action.error };

    default:
      return state;
  }
}
