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
  addToConsole(channel, surveyId) {
    return dispatch => {
      channel.push('set_console_mini_survey', { id: surveyId });
    }
  },
  create:(channel, params, callback) => {
    return dispatch => {
      channel.push('create_mini_survey', params)
      .receive('ok', (data) => {
        dispatch({ type: Constants.CREATE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  index:(channel, callback) => {
    return dispatch => {
      channel.push('mini_surveys')
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_SURVEYS, data: data.mini_surveys });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  answer:(channel, params, callback) => {
    return dispatch => {
      channel.push('answer_mini_survey', params)
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_CONSOLE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  getConsole:(channel, surveyId, callback) => {
    return dispatch => {
      channel.push('show_mini_survey', { id: surveyId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_CONSOLE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  viewAnswers:(channel, surveyId, callback) => {
    return dispatch => {
      channel.push('show_mini_survey_answers', { id: surveyId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_VIEW_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  delete:(channel, surveyId, callback) => {
    return dispatch => {
      channel.push('delete_mini_survey', { id: surveyId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.DELETE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  }
}

export default Actions;
