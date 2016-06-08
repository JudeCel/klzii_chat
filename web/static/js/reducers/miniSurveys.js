import Constants from '../constants';

const initialState = {
  list: [],
  console: {},
  view: { mini_survey_answers: [] }
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_SURVEYS:
      return { ...state, list: action.data };
    case Constants.SET_CONSOLE_SURVEY:
      return { ...state, console: action.data };
    case Constants.SET_VIEW_SURVEY:
      return { ...state, view: action.data };
    case Constants.CREATE_SURVEY:
      return { ...state, list: [ ...state.list, action.data ] };
    case Constants.DELETE_SURVEY:
      return { ...state, list: removeFromState(state, action.data.id) };
    default:
      return state;
  }
}

function removeFromState(state, removeId) {
  let array = [];

  state.list.map((survey) => {
    if(survey.id != removeId) {
      array.push(survey);
    }
  });

  return array;
}
