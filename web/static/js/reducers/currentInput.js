import Constants from '../constants';

const initialState = {
  value: '',
  action: 'new', // 'new', 'edit', 'reply'
  id: null,
  replyId: null,
  emotion: 1,
  inputPrefix: "Message:"
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.CHANGE_INPUT_VALUE:
      return { ...state, value: action.value };

    case Constants.SET_INPUT_DEFAULT_STATE:
      return initialState;

    case Constants.SET_INPUT_EDIT:
      if (state.action == 'edit' ) {
        return initialState;
      }else{
        return { ...state, action: 'edit', inputPrefix: "Edit:", id: action.id, value: action.value, emotion: action.emotion};
      }

    case Constants.SET_INPUT_EMOTION:
        return { ...state, emotion: action.emotion};

    case Constants.SET_INPUT_REPLY:
      if (state.action == 'reply' ) {
        return initialState;
      }else{
        return { ...initialState, action: 'reply', inputPrefix: "Reply:", replyId: action.replyId, value: ''};
      }
    default:
      return state;
  }
}
