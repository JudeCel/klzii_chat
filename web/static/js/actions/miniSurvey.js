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
  answer:(jwt, data, callback) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .post(`/api/mini_surveys/${ data.id }/answer`)
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .send({ answer: { type: data.type, value: data.value } })
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            dispatch({ type: Constants.SET_CONSOLE_SURVEY, data: result.body });
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
  },
  getConsole:(jwt, surveyId, sessionTopicId) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get(`/api/mini_surveys/${ surveyId }/console`)
        .query({ sessionTopicId: sessionTopicId })
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            dispatch({ type: Constants.SET_CONSOLE_SURVEY, data: result.body });
          }
        });
    }
  },
  view:(jwt, surveyId, sessionTopicId) => {
    return dispatch => {
      let csrf_token = localStorage.getItem('csrf_token');
      request
        .get(`/api/mini_surveys/${ surveyId }/console`)
        .query({ sessionTopicId: sessionTopicId })
        .set('X-CSRF-Token', csrf_token)
        .set('Authorization', jwt)
        .end(function(error, result) {
          if(error) {
            console.error(error);
          }
          else {
            console.error(result.body);
            dispatch({ type: Constants.SET_VIEW_SURVEY, data: result.body });
          }
        });
    }
  },
  addToConsole(channel, surveyId) {
    return dispatch => {
      channel.push('set_console_mini_survey', { id: surveyId });
    }
  }
}

export default Actions;
