import Constants from '../constants';

const initialState = {
  messages: [],
  currentUser: null,
  socket: null,
  channel: null,
  error: null,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.CURRENT_USER:
      return { ...state, currentUser: action.currentUser, error: null };

    case Constants.SOCKET_CONNECTED:
      return { ...state, socket: action.socket, channel: action.channel };

    case Constants.MESSAGES:
      return { ...state, socket: action.messages, channel: action.channel };

    case Constants.SOCKET_CONNECTION_ERROR:
      return { ...state, error: action.error };

    default:
      return state;
  }
}
