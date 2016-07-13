import Constants from '../constants';
import request   from 'superagent';
import NotificationActions from './notifications';

const Actions = {
  subscribePinboardEvents:(channel) => {
    return dispatch => {
      channel.on('new_pinboard_resource', (data) =>{
        return dispatch({ type: Constants.CHANGE_PINBOARD_RESOURCE, data: data });
      });
      channel.on('delete_pinboard_resource', (data) =>{
        return dispatch({ type: Constants.CHANGE_PINBOARD_RESOURCE, data: data });
      });
    }
  },
  enable:(channel) => {
    return dispatch => {
      channel.push('enable_pinboard')
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
      let csrf_token = localStorage.getItem("csrf_token");
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
        }
      });
    }
  }
}

export default Actions;