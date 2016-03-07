import Constants from '../constants';

const initialState = {
  video: [],
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_RESOURCE_VIDEO:
      return { ...state, video: [...video, action.video]};
    default:
      return state;
  }
}
