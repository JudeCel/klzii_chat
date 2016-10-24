import Constants from '../constants';
import NotificationActions from './notifications';

const Actions = {
  subscribeReportsEvents:(channel) => {
    return dispatch => {
      channel.on('session_topics_report_updated', (data) => {
        return dispatch({ type: Constants.UPDATE_REPORT, data: data });
      });
    }
  },
  index:(channel) => {
    return dispatch => {
      channel.push('get_session_topics_reports')
      .receive('ok', (data) => {
        console.log(data);
        dispatch({ type: Constants.SET_REPORTS, data: data });
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  create:(channel, params) => {
    return dispatch => {
      channel.push('create_session_topic_report', params)
      .receive('ok', (data) => {
        dispatch({ type: Constants.CREATE_REPORT, data: data });
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  recreate:(channel, reportId) => {
    return dispatch => {
      channel.push('recreate_session_topic_report', { id: reportId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.RECREATE_REPORT, data: data });
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  },
  delete:(channel, reportId) => {
    return dispatch => {
      channel.push('delete_session_topic_report', { id: reportId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.DELETE_REPORT, data: data });
      }).receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    }
  }
}

export default Actions;
