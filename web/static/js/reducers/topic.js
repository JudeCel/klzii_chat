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
