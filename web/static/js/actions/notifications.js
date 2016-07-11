import Constants from '../constants';

const Actions = {
  subscribeNotificationsEvents:(channel) => {
    return dispatch => {
      channel.on('show_notification', (data) => {
        return dispatch({ type: Constants.SHOW_NOTIFICATION, data: data });
      });
    }
  },
  showErrorNotification(dispatch, errors) {
    let messages = [];
    let keys = Object.keys(errors);

    keys.map((key, index) => {
      messages.push(_handleErrorType(key, errors[key]));
    });

    messages.map((error, index) => {
      dispatch({ type: Constants.SHOW_NOTIFICATION, data: error });
    });
  },
  showNotification(dispatch, data) {
    dispatch({ type: Constants.SHOW_NOTIFICATION, data: data });
  },
  clearNotification(dispatch) {
    dispatch({ type: Constants.CLEAR_NOTIFICATION });
  }
}

export default Actions;

var titles = {
  unhandled: 'Unhandled error',
  permissions: 'Not permitted',
  not_found: 'Not found',
  type: 'Type error',
  format: 'Format error',
  system: 'System error'
};

function _parentElement(children) {
  return `<ul>${children}</ul>`;
}

function _childElement(error) {
  return `<li>${error}</li>`;
}

function _handleErrorType(type, errors) {
  let isArray = errors instanceof Array;

  if(isArray) {
    if(errors.length > 1) {
      let children = '';
      errors.map((error, index) => {
        children += _childElement(error);
      });
      return { type: 'error', title: titles[type], message: _parentElement(children) };
    }
    else {
      return { type: 'error', title: titles[type], message: errors[0] };
    }
  }
  else {
    return { type: 'error', title: titles[type], message: errors };
  }
}
