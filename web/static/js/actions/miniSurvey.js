import Constants from '../constants';
import NotificationActions from './notifications';

const Actions = {
  addToConsole(channel, surveyId) {
    return dispatch => {
      channel.push('set_console_mini_survey', { id: surveyId });
    }
  },
  removeFromConsole:(channel) => {
    return dispatch => {
      channel.push('remove_console_element', { type: 'miniSurvey' });
    };
  },
  create:(channel, params, callback) => {
    return dispatch => {
      channel.push('create_mini_survey', params)
      .receive('ok', (data) => {
        dispatch({ type: Constants.CREATE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  index:(channel, callback) => {
    return dispatch => {
      channel.push('mini_surveys')
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_SURVEYS, data: data.mini_surveys });
        if(callback) callback();
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  answer:(channel, params, callback) => {
    return dispatch => {
      channel.push('answer_mini_survey', params)
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_CONSOLE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  getConsole:(channel, surveyId, callback) => {
    return dispatch => {
      channel.push('show_mini_survey', { id: surveyId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_CONSOLE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  viewAnswers:(channel, surveyId, callback) => {
    return dispatch => {
      channel.push('show_mini_survey_answers', { id: surveyId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_VIEW_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  delete:(channel, surveyId, callback) => {
    return dispatch => {
      channel.push('delete_mini_survey', { id: surveyId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.DELETE_SURVEY, data: data });
        if(callback) callback();
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  }
}

export default Actions;
