import Constants from '../constants';
import request   from 'superagent';

const Actions = {
  create:(jwt, data, callback) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .post('/api/mini_surveys')
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .send(data)
        .end(function(error, _) {
          if(error) {
            console.error(error);
          }
          else {
            callback();
          }
        });
    }
  },
  index:(jwt, sessionTopicId) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get('/api/mini_surveys')
        .query({ sessionTopicId: sessionTopicId })
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            dispatch({ type: Constants.SET_SURVEYS, data: result.body.mini_surveys });
          }
        });
    }
  }
}

export default Actions;
