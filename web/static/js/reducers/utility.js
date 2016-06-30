import Constants from '../constants';

const initialState = {
  window: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SCREEN_SIZE_CHANGED:
      return { ...state, window: action.window };
    default:
      return state;
  }
}
