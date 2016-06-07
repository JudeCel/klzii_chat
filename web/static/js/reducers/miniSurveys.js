import Constants from '../constants';

const initialState = {
  data: []
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SURVEYS:
      return { ...state, data: action.data };
    default:
      return state;
  }
}
