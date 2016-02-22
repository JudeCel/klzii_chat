import Constants from '../constants';

const initialState = {
  messages: [],
  channel: null,
  ready: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_TOPIC_HISTORY:
      return { ...state, messages: action.messages };

    case Constants.NEW_TOPIC_MESSAGE:
      return { ...state, messages: [ ...state.messages, action.message ] };

    case Constants.DELETE_TOPIC_MESSAGE:
      return { ...state, messages: delete_message(state.messages, action.message)};
    case Constants.UPDATE_TOPIC_MESSAGE:

      return { ...state, messages: update_message(state.messages, action.message)};

    case Constants.SET_TOPIC_EVENTS:
      return { ...state, ready: true };

    case Constants.SET_TOPIC_CHANNEL:
      return { ...state, channel: action.channel, ready: true};

    case Constants.SET_TOPIC_CHANNEL:
      return { ...state, channel: action.channel  };

    default:
      return state;
  }
}

function delete_message(messages, message) {
  let new_array = [];
  messages.map((e) => {
    if (!(e.id == message.id)) {
      new_array.push(e);
    }
  });
  return new_array
}

function update_message(messages, message) {
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
