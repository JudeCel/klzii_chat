import Constants from '../constants';

export default function reducer(state = {}, action = {}) {
  switch (action.type) {
    case Constants.SHOW_NOTIFICATION:
      return { ...action.data };
    case Constants.CLEAR_NOTIFICATION:
      return {};
    default:
      return state;
  }
}
