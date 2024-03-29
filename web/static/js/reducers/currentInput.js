import Constants from '../constants';

const initialState = {
  value: '',
  action: 'new', // 'new', 'edit', 'reply'
  id: null,
  replyId: null,
  emotion: 5,
  inputPrefix: "Message:",
  smallFont : false,
  replyColour: ""
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.CHANGE_INPUT_VALUE:
      return { ...state, value: action.value, smallFont: action.value.length >= 20 };

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
      if(state.action == 'reply' && state.replyId == action.replyId || action.replyId == null) {
        return initialState;
      }
      else {
        return { ...initialState, action: 'reply', inputPrefix: "Reply:", replyId: action.replyId, replyColour: action.replyColour, value: ''};
      }
    default:
      return state;
  }
}
