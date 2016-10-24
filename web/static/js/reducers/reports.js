import Constants from '../constants';

const initialState = {
  data: {},
  mapStruct: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_REPORTS:
      return { ...state, data: action.data };

    case Constants.SET_REPORT_MAP_STRUCT:
      return { ...state, mapStruct: action.mapStruct };
      
    case Constants.CREATE_REPORT:
    case Constants.UPDATE_REPORT:
      return { ...state, data: { ...state.data, ...formatSingleReport(state, action.data) } };
    default:
      return state;
  }
};

function formatSingleReport(state, report) {
  let object = { ...state.data[report.sessionTopicId] };
  object[report.format] = { ...object[report.format], [report.type]: report };
  return { [report.sessionTopicId]: object };
}
