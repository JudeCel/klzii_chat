import Constants from '../constants';

const initialState = {
  read: [],
  unread: [],
  unreadCount: {},
  last: {},
  current: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.UNREAD_DIRECT_MESSAGES:
    case Constants.READ_DIRECT_MESSAGES:
      return { ...state, unreadCount: action.data };
    case Constants.SET_DIRECT_MESSAGE_USER:
      return { ...state, current: action.id };
    case Constants.SET_DIRECT_MESSAGES:
      return { ...state, ...action.data };
    case Constants.CREATE_DIRECT_MESSAGE:
      return { ...state, ...createDirectMessage(state, action.data) };
    case Constants.NEW_DIRECT_MESSAGE:
      return { ...state, ...newDirectMessage(state, action.data) };
    case Constants.CLEAR_DIRECT_MESSAGES:
      return { ...state, read: [], unread: [] };
    case Constants.LAST_DIRECT_MESSAGES:
      return { ...state, last: action.data };
    default:
      return state;
  }
}

function createDirectMessage(state, message) {
  let object = { unread: state.unread, read: state.read };
  object.read = [...object.read, ...object.unread, message];
  object.unread = [];
  return object;
}

function newDirectMessage(state, message) {
  let object = {};

  if(state.current && state.current == message.senderId) {
    object = { unread: [...state.unread, message] };
  }
  else {
    object = { unreadCount: { ...state.unreadCount } };
    if(object.unreadCount[message.senderId]) {
      object.unreadCount[message.senderId]++;
    }
    else {
      object.unreadCount[message.senderId] = 1;
    }
  }

  object.last = { ...state.last };
  object.last[message.senderId] = message.text;

  return object;
}
