import Constants from '../constants';

const initialState = {
  currentUser: {},
  all: []
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_CURRENT_USER:
      return { ...state, currentUser: action.user };

    case Constants.SET_MEMBERS:
      return { ...state, all: action.members};

    default:
      return state;
  }
}
