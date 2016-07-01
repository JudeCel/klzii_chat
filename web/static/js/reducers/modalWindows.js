import Constants from '../constants';

const initialState = {
  console: false,
  resources: false,
  avatar: false,
  facilitatorBoard: false,
  reports: false,
  whiteboardText: false,
  currentModalData: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.OPEN_MODAL_WINDOW:
      return { ...state, [action.modal]: true, currentModalData: action.data || {} };
    case Constants.CLOSE_ALL_MODAL_WINDOWS:
      return initialState;
    default:
      return state;
  }
}
