import Constants from '../constants';

const initialState = {
  videos: [],
  images: [],
  audio: [],
  fetch: false,
  modalWindow: "" // "image", "video" "audio"
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.GET_RESOURCE:
      return { ...state, fetch: true, videos: [], images: [], audio: [], file: [] };
    case Constants.CLEAN_RESOURCE:
      return initialState;
    case Constants.SET_VIDEO_RESOURCES:
      return { ...state, fetch: false, videos: action.resources};
    case Constants.SET_IMAGE_RESOURCES:
      return { ...state, fetch: false, images: action.resources};
    case Constants.SET_AUDIO_RESOURCES:
      return { ...state, fetch: false, audio: action.resources};
    case Constants.SET_FILE_RESOURCES:
      return { ...state, fetch: false, file: action.resources};
    case Constants.OPEN_RESOURCE_MODAL:
      return { ...state, modalWindow: action.modal };
    case Constants.CLOASE_RESOURCE_MODAL:
      return { ...state, modalWindow: "" };
    default:
      return state;
  }
}
