import Constants from '../constants';

const initialState = {
  videos: [],
  images: [],
  audios: [],
  files: [],
  fetch: false,
  modalWindow: "" // "image", "video" "audio"
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.GET_RESOURCE:
      return { ...state, fetch: true, videos: [], images: [], audio: [], file: [] };
    case Constants.CLEAN_RESOURCE:
      return initialState;
    case Constants.DELETE_RESOURCES:
      return deleteResource(state, action.resp.type, action.resp.id);
    case Constants.SET_VIDEO_RESOURCES:
      return { ...state, fetch: false, videos: [...state.videos, ...action.resources]};
    case Constants.SET_IMAGE_RESOURCES:
      return { ...state, fetch: false, images: [...state.images, ...action.resources]};
    case Constants.SET_AUDIO_RESOURCES:
      return { ...state, fetch: false, audios: [...state.audios, ...action.resources]};
    case Constants.SET_FILE_RESOURCES:
      return { ...state, fetch: false, files: [...state.files, ...action.resources]};
    case Constants.OPEN_RESOURCE_MODAL:
      return { ...state, modalWindow: action.modal };
    case Constants.CLOASE_RESOURCE_MODAL:
      return { ...state, modalWindow: "" };
    default:
      return state;
  }
}

function deleteResource(state, type, id) {
  let newArray = [];
  state[pluralizeTypeName(type)].map((r) => {
    if (r.id != id) {
      newArray.push(r);
    }
  });
  let newState = { ...state };
  newState[pluralizeTypeName(type)] = newArray;
  return newState
}

function pluralizeTypeName(name) {
  switch (name) {
    case 'image':
      return 'images'
    case 'video':
      return 'videos'
    case 'audio':
      return 'audios'
    case 'file':
      return 'files'
    default:
      return name
  }
}
