import Constants from '../constants';

const initialState = {
  message: "",
  title:"",
  type:""
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SHOW_NOTIFICATION:
      return { ...action.data };
    case Constants.CLEAR_NOTIFICATION:
      return initialState;
    default:
      return state;
  }
};
