import Constants from '../constants';

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
  subscribeReportsEvents:(channel) => {
    return dispatch => {
      channel.on('report_updated', (data) => {
        return dispatch({ type: Constants.UPDATE_REPORT, data: data });
      });
    }
  },
  index:(channel, callback) => {
    return dispatch => {
      channel.push('get_session_reports')
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_REPORTS, data: data.reports });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  create:(channel, params, callback) => {
    return dispatch => {
      channel.push('create_session_topic_report', params)
      .receive('ok', (data) => {
        dispatch({ type: Constants.CREATE_REPORT, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  recreate:(channel, reportId, callback) => {
    return dispatch => {
      channel.push('recreate_session_topic_report', { id: reportId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.RECREATE_REPORT, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  delete:(channel, reportId, callback) => {
    return dispatch => {
      channel.push('delete_session_topic_report', { id: reportId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.DELETE_REPORT, data: data });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  }
}

export default Actions;
