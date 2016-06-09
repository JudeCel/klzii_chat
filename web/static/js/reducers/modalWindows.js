import Constants from '../constants';

const initialState = {
  console: false,
  resources: false,
  avatar: false,
  facilitatorBoard: false,
  data: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.OPEN_MODAL_WINDOW:
      let newState = { [action.modal]: true, data: action.data || {} };
      return { ...state, ...newState };
    case Constants.CLOSE_ALL_MODAL_WINDOWS:
      return initialState;
    default:
      return state;
  }
}
