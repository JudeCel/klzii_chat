import Constants from '../constants';
import request   from 'superagent';
import NotificationActions from './notifications';

const Actions = {
  subscribePinboardEvents:(channel) => {
    return dispatch => {
      channel.on('new_pinboard_resource', (data) =>{
        dispatch({ type: Constants.CHANGE_PINBOARD_RESOURCE, data: data });
      });
      channel.on('delete_pinboard_resource', (data) =>{
        dispatch({ type: Constants.CHANGE_PINBOARD_RESOURCE, data: data });
      });
      channel.on('pinboard_resources', (data) =>{
        dispatch({ type: Constants.GET_PINBOARD_RESOURCES, data: data.list });
      });
    }
  },
  enable:(channel, enable) => {
    return dispatch => {
      channel.push(enable ? 'enable_pinboard' : 'disable_pinboard')
      .receive('ok', (data) => {
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  get:(channel) => {
    return dispatch => {
      channel.push('get_pinboard_resources')
      .receive('ok', (data) => {
        dispatch({ type: Constants.GET_PINBOARD_RESOURCES, data: data.list });
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  delete:(channel, id) => {
    return dispatch => {
      channel.push('delete_pinboard_resource', { id })
      .receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  upload:(data, jwt) => {
    return (dispatch) => {
      if (data.files) {
        let csrf_token = localStorage.getItem("csrf_token");
        dispatch({ type: Constants.MODAL_POST_DATA });
        let req = request.post('/api/pinboard_resource/upload')
           .set('X-CSRF-Token', csrf_token)
           .set('Authorization', jwt);

        data.files.map((file) => {
          req.attach('file', file)
             .field('type', data.type)
             .field('sessionTopicId', data.sessionTopicId)
             .field('scope', data.scope)
             .field('name', data.name);
        });

        req.end((errors, result) => {
          if(errors) {
            NotificationActions.showErrorNotification(dispatch, errors);
          } else {
            dispatch({ type: Constants.MODAL_POST_DATA_DONE_AND_CLOSE });
          }
        });
      } else {
        dispatch({ type: Constants.MODAL_POST_DATA_DONE_AND_CLOSE });
      }
    }
  }
}

export default Actions;
