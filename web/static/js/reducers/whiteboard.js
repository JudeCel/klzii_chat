import Constants from '../constants';

const initialState = {
  shapes: [],
  channel: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_WHITEBOARD_SHAPE:
      return { ...state, shapes: [...state.shapes, action.shape]};

    case Constants.UPDATE_WHITEBOARD_SHAPE:
      return { ...state, shapes: findAndUpdate(state.shapes, action.shape)};

    case Constants.DELETE_WHITEBOARD_SHAPE:
      return { ...state, shapes: findAndDelete(state.shapes, action.shape)};

    case Constants.SET_WHITEBOARD_CHANNEL:
      return { ...state, channel: action.channel};

    case Constants.SET_WHITEBOARD_HISTORY:
      return { ...state, shapes: action.objects};

    case Constants.DELETE_ALL_WHITEBOARD_SHAPES:
      return { ...state, shapes: []};

    default:
      return state;
  }
}
function findAndUpdate(list, element) {
  let newList = [];
   list.map((e) => {
    if (e.id == element.id) {
      newList.push(Object.assign(e, element));
    }else{
      newList.push(e);
    }
  });
  return newList;
}
function findAndDelete(list, element) {
  let newList = [];
   list.map((e) => {
    if (e.uid != element.uid) {
      newList.push(e);
    }
  });
  return newList;
}
