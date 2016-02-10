import Constants from '../constants';

const initialState = {
  objects: [],
  ready: false,
  needEvents: true,
  readyToBuild: false,
  isBuild: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_WHITEBOARD_READY:
      return { ...state, ready: true};

    case Constants.SET_WHITEBOARD_EVENTS:
      return { ...state, needEvents: false};

    case Constants.SET_WHITEBOARD_HISTORY:
      return { ...state, objects: action.objects, readyToBuild: true};

    case Constants.SET_WHITEBOARD_BUILT:
      return { ...state, isBuild: true};
    default:
      return state;
  }
}
