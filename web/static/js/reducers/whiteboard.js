import Constants from '../constants';

const initialState = {
  shapes: {},
  channel: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_WHITEBOARD_SHAPE:
      return { ...state, shapes: mapToObject({...state.shapes}, [action.shape]) };

    case Constants.UPDATE_WHITEBOARD_SHAPE:
      return { ...state, shapes: mapToObject({...state.shapes}, [action.shape])};

    case Constants.DELETE_WHITEBOARD_SHAPE:
      return { ...state, shapes: findAndDelete({...state.shapes}, [action.shape])};

    case Constants.SET_WHITEBOARD_CHANNEL:
      return { ...state, ...initialState, channel: action.channel };

    case Constants.SET_WHITEBOARD_HISTORY:
      return { ...state, shapes: mapToObject({...state.shapes}, action.objects) };

    case Constants.DELETE_ALL_WHITEBOARD_SHAPES:
      return { ...state, shapes: findAndDelete({...state.shapes}, action.shapes)};

    case Constants.TIDY_UP_WHITEBOARD:
      return { ...state, shapes: {} };

    default:
      return state;
  }
}

function mapToObject(shapes, elements) {
  elements.map((item) => {
    shapes[item.uid] = item
  })
  return shapes
}

function findAndDelete(shapes, elements) {
  elements.map((item) => {
    delete shapes[item.uid]
  })
  return shapes
}
