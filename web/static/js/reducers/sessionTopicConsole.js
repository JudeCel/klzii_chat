import Constants from '../constants';

const initialState = {
  data: {},
  consoleResource: {},
  postingData: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_CONSOLE:
      return { ...state, data: action.console, postingData: false };

    case Constants.POSTING_DATA_CONSOLE:
      return { ...state, postingData: true };

    case Constants.POSTING_DATA_CONSOLE_DONE:
      return { ...state, postingData: false };

    case Constants.SET_CONSOLE_RESOURCE:
      return { ...state, consoleResource: action.data, postingData: false };

    case Constants.TIDY_UP_CONSOLE:
      return initialState;

    default:
      return state;
  }
}
