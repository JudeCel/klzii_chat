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
    case "gallery":
      dispatch({type: Constants.SET_GALLERY_RESOURCES, gallery: resp.resources });
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
  removeSessionResources:(jwt, data) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .delete('/api/session_resources/remove_resources')
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .send({ resourceIds: data })
        .end();
    }
  },
  createSessionResources:(jwt, data) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .post('/api/session_resources/add_resources')
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .send({ resourceIds: data })
        .end();
    }
  },
  listSessionResources:(jwt, data) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get('/api/session_resources')
        .query({ 'type[]': data.type, 'scope[]': data.scope })
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            dispatchByType(dispatch, { type: data.type[0], resources: result.body });
          }
        });
    }
  },
  getConsoleResource:(jwt, resourceId) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get('/api/resources/' + resourceId)
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            dispatch({ type: Constants.SET_CONSOLE_RESOURCE, data: result.body.resource });
          }
        });
    }
  },
  getGalleryList:(jwt, data) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get('/api/session_resources/gallery')
        .query({ 'type[]': data.type, 'scope[]': data.scope })
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            dispatchByType(dispatch, { type: 'gallery', resources: result.body.resources });
          }
        });
    }
  },
  youtube:(data, jwt) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .post('/api/session_resources/upload')
        .send(data)
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            console.error(result.body.resource);
            dispatchByType(dispatch, { type: 'video', resources: [result.body.resource] });
          }
        });
    }
  },
  upload:(data, jwt) =>{
    return (dispatch) => {
      let csrf_token = localStorage.getItem("csrf_token");
      let req = request.post('/api/session_resources/upload');
      req.set('X-CSRF-Token', csrf_token);
      req.set('Authorization', jwt);
      data.files.map((file)=> {
        req.attach("file", file);
        req.field("type", data.type);
        req.field("scope", data.scope);
        req.field("name", data.name);
      });
      req.end((error, result) =>{
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
  },
}

export default Actions;
