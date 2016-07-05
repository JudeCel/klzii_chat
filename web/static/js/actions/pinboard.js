import Constants from '../constants';
import request   from 'superagent';

function _errorData(data) {
  return {
    type: Constants.SHOW_NOTIFICATION,
    data: {
      type: 'error',
      message: data.error
    }
  };
}

const Actions = {
  // subscribePinboardEvents:(channel) => {
  //   return dispatch => {
  //     channel.on('get_pinboard_resources', (data) =>{
  //       return dispatch({ type: Constants.GET_PINBOARD_RESOURCES, data: data });
  //     });
  //   }
  // },
  enable:(channel) => {
    return dispatch => {
      channel.push('enable_pinboard')
      .receive('ok', (data) => {
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  get:(channel) => {
    return dispatch => {
      channel.push('get_pinboard_resources')
      .receive('ok', (data) => {
        dispatch({ type: Constants.GET_PINBOARD_RESOURCES, data: data.list });
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  delete:(channel) => {
    return dispatch => {
      channel.push('delete_pinboard_resource')
      .receive('ok', (data) => {
        // dispatch({ type: Constants.CHANGE_PINBOARD_RESOURCE, data: data });
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  upload:(data, jwt) =>{
    return (dispatch) => {
      let csrf_token = localStorage.getItem("csrf_token");
      let req = request.post('/api/pinboard_resource/upload')
         .set('X-CSRF-Token', csrf_token)
         .set('Authorization', jwt);

      data.files.map((file)=> {
        req.attach('file', file)
           .field('type', data.type)
           .field('sessionTopicId', data.sessionTopicId)
           .field('scope', data.scope)
           .field('name', data.name);
      });

      req.end((error, result) =>{
        if(error) {
          dispatch(_errorData(error));
        }
        else {
          dispatch({ type: Constants.CHANGE_PINBOARD_RESOURCE, data: result.body.pinboard_resource });
        }
      });
    }
  }
}

export default Actions;
