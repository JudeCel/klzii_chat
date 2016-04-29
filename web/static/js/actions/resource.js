import Constants from '../constants';
import request   from 'superagent';

function dispatchByType(dispatch, resp) {
  switch (resp.type) {
    case "video":
      dispatch({type: Constants.SET_VIDEO_RESOURCES, resources: resp.resources });
      break;
    case "image":
      dispatch({type: Constants.SET_IMAGE_RESOURCES, resources: resp.resources });
      break;
    case "audio":
      dispatch({type: Constants.SET_AUDIO_RESOURCES, resources: resp.resources });
      break;
    case "file":
      dispatch({type: Constants.SET_FILE_RESOURCES, resources: resp.resources });
      break;
    default:
  }
}

const Actions = {
  subscribeEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_MESSAGES_EVENTS});
      channel.on("resources", (resp) =>{
        dispatch({ type: Constants.SET_MESSAGES_EVENTS});
        return new_message(dispatch, resp);
      });
    }
  },
  upload:(files, type, jwt, name) =>{
    return (dispatch) => {
      let csrf_token = localStorage.getItem("csrf_token");
      let req = request.post('/api/resources/upload');
      req.set('X-CSRF-Token', csrf_token);
      req.set('Authorization', jwt);
      files.map((file)=> {
        req.attach("file", file);
        req.field("type", type);
        req.field("scope", "collage");
        req.field("name", name);
      });
      req.end((error, result) =>{
        console.log(error);
        if (result) {
          dispatchByType(dispatch, {type: result.body.type, resources: [result.body.resource]})
        }
      });
    }
  },
  get:(channel, type) => {
    return dispatch => {
      dispatch({ type: Constants.GET_RESOURCE });
      channel.push("resources", {type: type}).receive('ok', (resp) =>{
        dispatchByType(dispatch, resp);
      })
    }
  },
  delete:(channel, id) => {
    return dispatch => {
      channel.push("deleteResources", { id: id }).receive('ok', (resp) =>{
        dispatch({type: Constants.DELETE_RESOURCES, resp: resp})
      })
    }
  }
}

export default Actions;
