import Constants from '../constants';

const initialState = {
  data: [],
  console: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SURVEYS:
      return { ...state, data: action.data };
    case Constants.SET_CONSOLE_SURVEY:
      return { ...state, console: action.data };
    default:
      return state;
  }
}
