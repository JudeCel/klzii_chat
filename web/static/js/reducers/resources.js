import Constants from '../constants';

const initialState = {
  videos: [],
  images: [],
  audios: [],
  files: [],
  gallery: [],
  fetch: false,
  pages: 0
};

export default function reducer(state = initialState, action = {}) {
  if(action.resources && action.resources[0] && action.resources[0].resource == null) {
    return state;
  }
  switch (action.type) {
    case Constants.GET_RESOURCE:
      return { ...state, fetch: true, videos: [], images: [], audio: [], file: [] };
    case Constants.CLEAN_RESOURCE:
      return initialState;
    case Constants.DELETE_RESOURCES:
      return deleteResource(state, action.resp.type, action.resp.id);
    case Constants.SET_VIDEO_RESOURCES:
      return { ...state, fetch: false, videos: action.resources };
    case Constants.SET_IMAGE_RESOURCES:
      return { ...state, fetch: false, images: action.resources };
    case Constants.SET_AUDIO_RESOURCES:
      return { ...state, fetch: false, audios: action.resources };
    case Constants.SET_FILE_RESOURCES:
      return { ...state, fetch: false, files: action.resources };
    case Constants.SET_GALLERY_RESOURCES:
      return { ...state, fetch: false, gallery: action.gallery, pages: action.pages};
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
    case 'link':
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
