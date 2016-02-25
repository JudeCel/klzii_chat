import Constants from '../constants';

const initialState = {
  currentUser: {},
  facilitator: {},
  participants: [],
  observers: []
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_CURRENT_USER:
      return { ...state, currentUser: action.user };

    case Constants.SET_MEMBERS:
      return { ...state,
        facilitator: action.facilitator,
        observers: action.observer,
        participants: action.participant
      };

    default:
      return state;
  }
}
