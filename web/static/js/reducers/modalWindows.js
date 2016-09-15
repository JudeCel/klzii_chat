import Constants from '../constants';

const initialState = {
  console: false,
  resources: false,
  avatar: false,
  facilitatorBoard: false,
  reports: false,
  whiteboardText: false,
  whiteboardImage: false,
  observerList: false,
  postData: false,
  currentModalData: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.OPEN_MODAL_WINDOW:
      return { ...state, [action.modal]: true, currentModalData: action.data || {} };
    case Constants.MODAL_POST_DATA:
      return { ...state, postData: true };
    case Constants.MODAL_POST_DATA_DONE_AND_CLOSE:
      return initialState;
    case Constants.MODAL_POST_DATA_DONE:
      return { ...state, postData: false };
    case Constants.CLOSE_ALL_MODAL_WINDOWS:
      return initialState;
    default:
      return state;
  }
}
