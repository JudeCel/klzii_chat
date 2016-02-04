import Constants from '../constants';

const initialState = {
  messages: [],
  currentUser: {},
  socket: null,
  channel: null,
  error: null,
  fetching: true,
  needSetEvents: true
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SOCKET_CONNECTED_FETCHING:
      return { ...state, fetching: true };

    case Constants.SOCKET_EVENT_FETCHING:
      return { ...state, fetching: true };

    case Constants.SET_SOCKET_EVENTS:
      return { ...state, needSetEvents: false };

    case Constants.CURRENT_USER:
      return { ...state, currentUser: action.currentUser, error: null };

    case Constants.SOCKET_CONNECTED:
      return {  ...state,
                fetching: false,
                currentUser: action.currentUser,
                socket: action.socket,
                channel: action.channel
             };

    case Constants.HISTORY_MESSAGES:
      return { ...state, messages:  action.messages.concat(messages) };

    case Constants.NEW_MESSAGE:
      return { ...state, messages: [...state.messages, action.message ] };

    case Constants.SOCKET_CONNECTION_ERROR:
      return { ...state, error: action.error };

    default:
      return state;
  }
}
