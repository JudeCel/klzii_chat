import Constants from '../constants';

const initialState = {
  data: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_REPORTS:
      return { ...state, data: action.data };
    case Constants.CREATE_REPORT, Constants.UPDATE_REPORT:
      return { ...state, data: { ...state.data, ...formatSingleReport(action.data) } };
    default:
      return state;
  }
};

function formatSingleReport(report) {
  return { [report.sessionTopicId]: { [report.format]: { [report.type]: report } } };
}
