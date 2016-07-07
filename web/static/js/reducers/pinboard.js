import Constants from '../constants';

const initialState = {
  items: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.GET_PINBOARD_RESOURCES:
      return { ...state, items: mapArrayToObject(action.data) };
    case Constants.CHANGE_PINBOARD_RESOURCE:
      return { ...state, items: { ...state.items, [action.data.id]: action.data } };
    default:
      return state;
  }
}

function mapArrayToObject(data) {
  let object = {};

  data.map((item) => {
    object[item.id] = item;
  });

  return object;
}
