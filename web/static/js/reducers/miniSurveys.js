import Constants from '../constants';

const initialState = {
  data: [],
  console: {},
  view: { answers: [] }
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SURVEYS:
      return { ...state, data: action.data };
    case Constants.SET_CONSOLE_SURVEY:
      return { ...state, console: action.data };
    case Constants.SET_VIEW_SURVEY:
      return { ...state, view: action.data };
    default:
      return state;
  }
}
