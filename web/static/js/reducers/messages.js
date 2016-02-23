import Constants from '../constants';

const initialState = {
  all: [],
  ready: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_MESSAGES:
      return { ...state, all: action.messages };

    case Constants.NEW_MESSAGE:
      return { ...state, all: updateMessage(state.all, action.message) };

    case Constants.DELETE_MESSAGE:
      return { ...state, all: deleteMessage(state.all, action.message)};

    case Constants.UPDATE_MESSAGE:
      return { ...state, all: updateMessage(state.all, action.message)};

    case Constants.SET_MESSAGES_EVENTS:
      return { ...state, ready: true };
    default:
      return state;
  }
}

function deleteMessage(messages, message) {
  let new_array = [];
  messages.map((e) => {
    if (!(e.id == message.id)) {
      new_array.push(e);
    }
  });
  return new_array
}

function updateMessage(messages, message) {
  let new_array = [];
  messages.map((e) => {
    if ((e.id == message.id)) {
      new_array.push({...message, e});
    }else {
      new_array.push(e);
    }
  });
  return new_array
}
