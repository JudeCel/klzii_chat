import Constants from '../constants';

const initialState = {
  read: [],
  unread: []
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_DIRECT_MESSAGES:
      return { ...state, ...action.data };
    case Constants.CREATE_DIRECT_MESSAGE:
      return { ...state, read: [...state.read, action.data] };
    default:
      return state;
  }
}
