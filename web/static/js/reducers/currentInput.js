import Constants from '../constants';

const initialState = {
  value: '',
  action: 'new', // 'new', 'edit', 'reply'
  id: null,
  replyId: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.CHANGE_INPUT_VALUE:
      return { ...state, value: action.value };

    case Constants.SET_INPUT_DEFAULT_STATE:
      return { ...state, action: 'new', id: null, value: '' };

    case Constants.SET_INPUT_EDIT:
      return { ...state, action: 'edit', id: action.id, value: action.value};

    case Constants.SET_INPUT_REPLY:
      return { ...state, action: 'reply', replyId: action.replyId, value: ''};

    default:
      return state;
  }
}
