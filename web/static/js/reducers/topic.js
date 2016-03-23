import Constants from '../constants';

const initialState = {
  current: { id: 0, name: 'Topic' },
  channel: null,
  all: [],
  ready: false,
  leave: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_TOPIC_CHANNEL:
      return { ...state, current: find(state.all, action.currentId), channel: action.channel, ready: true};

    case Constants.SET_TOPICS:
      return { ...state, all: action.all};

    case Constants.LEAVE_TOPIC:
      return { ...state, channel: null, current: {}, leave: true };
    default:
      return state;
  }
}
function find(toics, id) {
  let topic = null;
  toics.map((t) =>{
    if (t.id == id) {
      topic = t;
    }
  })
  return topic;
}
