import Constants from '../constants';

const initialState = {
  console: false,
  resources: false,
  avatar: false,
  facilitatorBoard: false,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.OPEN_MODAL_WINDOW:
      let newState = {};
      newState[action.modal] = true;
      return { ...state, ...newState };
    case Constants.CLOSE_ALL_MODAL_WINDOWS:
      return initialState;
    default:
      return state;
  }
}
