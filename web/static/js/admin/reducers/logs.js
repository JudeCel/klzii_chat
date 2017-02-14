const initialState = {
  socket: null,
  channel: null,
  error: null,
  ready: false,
  filters: {},
  collection: []
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case 'SET_SOCKET_EVENTS':
      return { ...state, ready: true };
    case 'SOCKET_CONNECTION_ERROR':
      return { ...state, error: action.error };
    case 'NEW_LOG_ENTRY':
      return { ...state, collection: [...state.collection, ...[action.entry]] };
    case 'SET_LOGS_DATA':
      return { ...state, collection: action.resp.history, filters:  action.resp.filters};
    default:
      return state;
  }
}
