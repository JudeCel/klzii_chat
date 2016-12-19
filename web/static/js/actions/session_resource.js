import Constants from '../constants';
import request   from 'superagent';
import NotificationActions from './notifications';

function dispatchByType(dispatch, resp) {
  switch (resp.type) {
    case "link":
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
      dispatch({type: Constants.SET_GALLERY_RESOURCES, gallery: resp.resources, pages: resp.pages });
      break;
    default:
  }
}

const Actions = {
  delete:(jwt, id) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .delete(`/api/session_resources/${id}`)
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .send({ id })
        .end(function(error, resp) {
          if(error) {
            NotificationActions.showErrorNotification(dispatch, error);
          }else {
            dispatch({type: Constants.DELETE_RESOURCES, resp: resp.body });
          }
        });
    }
  },
  create:(jwt, data, type) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .post('/api/session_resources/create')
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .send({ ids: data })
        .end(function(error, _) {
          if(error) {
            NotificationActions.showErrorNotification(dispatch, error);
          }else{
            dispatch(Actions.index(jwt, { type: [type] }));
            dispatch({type: Constants.SET_GALLERY_RESOURCES, gallery: []});
          }
        });
    }
  },
  index:(jwt, data) => {
    if (data.type[0] && !data.type[1]) {
      if (data.type[0] == "video") {
        data.type.push("link");
      } else if (data.type[0] == "link") {
        data.type.push("video");
      }
    }
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get('/api/session_resources')
        .query({ 'type[]': data.type, 'scope[]': data.scope })
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            NotificationActions.showErrorNotification(dispatch, error);
          }
          else {
            dispatchByType(dispatch, { type: data.type[0], resources: result.body });
          }
        });
    }
  },
  getGallery:(jwt, data) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get('/api/session_resources/gallery')
        .query({ 'type[]': data.type, 'scope[]': data.scope, 'page': data.page  })
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            NotificationActions.showErrorNotification(dispatch, error);
          }
          else {
            dispatchByType(dispatch, { type: 'gallery', resources: result.body.resources, pages: result.body.pages });
          }
        });
    }
  },
  getConsoleResource:(jwt, resourceId) => {
    return dispatch => {
     let csrf_token = localStorage.getItem('csrf_token');
     dispatch({ type: Constants.MODAL_POST_DATA });
     request
       .get('/api/resources/' + resourceId)
       .set('X-CSRF-Token', csrf_token)
       .set('Authorization', jwt)
       .end(function(error, result) {
         if(error) {
           NotificationActions.showErrorNotification(dispatch, error);
         }
         else {
           dispatch({ type: Constants.MODAL_POST_DATA_DONE });
          dispatch({ type: Constants.SET_CONSOLE_RESOURCE, data: result.body.resource });
         }
       });
    }
  },
  videoService:(data, jwt) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .post('/api/session_resources/upload')
        .send(data)
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            NotificationActions.showErrorNotification(dispatch, error);
          } else {
            dispatch(Actions.index(jwt, { type: [data.type] }));
          }
        });
    }
  },
  upload:(data, jwt) =>{
    return (dispatch) => {
      dispatch({ type: Constants.MODAL_POST_DATA });
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
        if(error) {
          NotificationActions.showErrorNotification(dispatch, error);
        }
        else {
          dispatch({ type: Constants.MODAL_POST_DATA_DONE });
          dispatch(Actions.index(jwt, { type: [data.type] }));
        }
      });
    }
  }
}

export default Actions;
