import Constants from '../constants';

const initialState = {
  read: [],
  unread: [],
  unreadCount: {},
  last: {},
  currentReciever: null,
  currentPage: 0,
  fetching: false,
  canFetch: true,
  perPage: 10
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.UNREAD_DIRECT_MESSAGES:
    case Constants.READ_DIRECT_MESSAGES:
      return { ...state, unreadCount: action.data };
    case Constants.SET_DIRECT_MESSAGES:
      return { ...state, ...action.data, fetching: false, canFetch: true };
    case Constants.ADD_DIRECT_MESSAGES:
      return { ...state, ...addDirectMessages(state, action.data) };
    case Constants.CREATE_DIRECT_MESSAGE:
      return { ...state, ...createDirectMessage(state, action.data) };
    case Constants.NEW_DIRECT_MESSAGE:
      return { ...state, ...newDirectMessage(state, action.data) };
    case Constants.CLEAR_DIRECT_MESSAGES:
      return { ...state, ...initialState };
    case Constants.LAST_DIRECT_MESSAGES:
      return { ...state, last: action.data };
    case Constants.FETCHING_DIRECT_MESSAGES:
      return { ...state, fetching: true };
    default:
      return state;
  }
}

function createDirectMessage(state, message) {
  let object = { unread: state.unread, read: state.read };
  if((object.unread.length + object.read.length) < state.perPage) {
    object.canFetch = false;
  }

  object.read = [...object.read, ...object.unread, message];
  object.unread = [];
  return object;
}

function newDirectMessage(state, message) {
  let object = {};

  if(state.currentReciever && state.currentReciever == message.senderId) {
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

function addDirectMessages(state, data) {
  let object = { read: [...data.read, ...state.read], currentPage: data.currentPage, fetching: false };

  if(data.read.length < state.perPage) {
    object.canFetch = false;
  }

  return object;
}
