import Constants from '../constants';

const initialState = {
  current: {},
  channel: null,
  all: [],
  ready: false,
  leave: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SESSION_TOPIC_CHANNEL:
      return { ...state, current: find(state.all, action.currentId), channel: action.channel, ready: true};

    case Constants.SET_SESSION_TOPICS:
      return { ...state, all: action.all};

    case Constants.CHANGE_SESSION_TOPICS:
      return { ...state, all: action.all};

    case Constants.UPDATE_SESSION_TOPIC:
      return { ...state, all: findAndUpdate(state.all, action.session_topic)};

    case Constants.SET_SESSION_TOPIC:
      return { ...state, channel: null, current: {}, leave: true };

    default:
      return state;
  }
}
function find(sessionTopics, id) {
  return sessionTopics.find((st) => {
    return st.id == id
  });
}

function findAndUpdate(session_topics, session_topic) {
  let newSession_topics = [];
   session_topics.map((st) => {
    if (st.id == session_topic.id) {
      newSession_topics.push(Object.assign(st, session_topic));
    }else{
      newSession_topics.push(st);
    }
  });
  return newSession_topics;
}
