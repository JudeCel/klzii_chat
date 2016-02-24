import Constants from '../constants';

const initialState = {
  channel: null,
  ready: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_TOPIC_CHANNEL:
      return { ...state, channel: action.channel, ready: true};
      
    default:
      return state;
  }
}
