import Constants from '../constants';

const initialState = {
  current: {},
  channel: null,
  all: [],
  ready: false,
  leave: false,
  console: {},
  consoleResource: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SESSION_TOPIC_CHANNEL:
      return { ...state, current: find(state.all, action.currentId), channel: action.channel, ready: true};

    case Constants.SET_SESSION_TOPICS:
      return { ...state, all: action.all};

    case Constants.SET_SESSION_TOPIC:
      return { ...state, channel: null, current: {}, leave: true };

    case Constants.SET_CONSOLE:
      return { ...state, console: action.console };

    case Constants.SET_CONSOLE_RESOURCE:
      return { ...state, consoleResource: action.data };

    default:
      return state;
  }
}
function find(sessionTopics, id) {
  return sessionTopics.find((st) => {
    return st.id == id
  });
}
