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
      return { ...state, fetch: true };
    case Constants.SET_VIDEO_RESOURCES:
      return { ...state, fetch: false, videos: action.videos};
    case Constants.SET_IMAGE_RESOURCES:
      return { ...state, fetch: false, images: action.images};
    case Constants.SET_AUDIO_RESOURCES:
      return { ...state, fetch: false, audio: action.audio};

    case Constants.OPEN_RESOURCE_MODAL:
      return { ...state, modalWindow: action.modal };
    case Constants.CLOASE_RESOURCE_MODAL:
      return { ...state, modalWindow: "" };
    default:
      return state;
  }
}
