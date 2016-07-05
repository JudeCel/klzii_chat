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
  // subscribeDirectMessageEvents:(channel) => {
  //   return dispatch => {
  //     channel.on('new_direct_message', (data) =>{
  //       return dispatch({ type: Constants.NEW_DIRECT_MESSAGE, data: data });
  //     });
  //   }
  // },
  enablePinboard:(channel) => {
    return dispatch => {
      channel.push('enable_pinboard')
      .receive('ok', (data) => {
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
          console.error(error);
          dispatch(_errorData(error));
        }
        else {
          console.error(result);
          // dispatch(Actions.index(jwt, { type: [data.type] }));
        }
      });
    }
  }
}

export default Actions;
