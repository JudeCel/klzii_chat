import Constants from '../constants';
import request   from 'superagent';

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
  upload:(files, type, memberId, topicId) =>{
    return (dispatch) => {

      let csrf_token = localStorage.getItem("csrf_token");
      let req = request.post('/upload');
      req.set('X-CSRF-Token', csrf_token);

      files.map((file)=> {
        req.attach("file", file);
        req.field("memberId", memberId);
        req.field("topicId", topicId);
        req.field("type", type);
        req.field("scope", "collage");
      });

      req.end((e, r) =>{
        console.log(r);
      });
    }
  },
  getResource:(channel, type) => {
    return dispatch => {
      dispatch({ type: Constants.GET_RESOURCE });
      channel.push("resources", {type: type}).receive('ok', (resp) =>{
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
      })
    }
  }
}

export default Actions;
