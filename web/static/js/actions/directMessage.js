import Constants  from '../constants';

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
  subscribeDirectMessageEvents:(channel) => {
    return dispatch => {
      channel.on('new_direct_message', (data) =>{
        return dispatch({ type: Constants.NEW_DIRECT_MESSAGE, data: data });
      });
    }
  },
  getUnreadCount:(channel) => {
    return dispatch => {
      channel.push('get_unread_count')
      .receive('ok', (data) => {
        dispatch({ type: Constants.UNREAD_DIRECT_MESSAGES, data: data.count });
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  index:(channel, recieverId, callback) => {
    return dispatch => {
      channel.push('get_all_direct_messages', { recieverId, page: 0 })
      .receive('ok', (data) => {
        dispatch({ type: Constants.SET_DIRECT_MESSAGE_USER, id: recieverId });
        dispatch({ type: Constants.SET_DIRECT_MESSAGES, data: data.messages });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  nextPage:(channel, recieverId, page, callback) => {
    return dispatch => {
      dispatch({ type: Constants.FETCHING_DIRECT_MESSAGES });
      channel.push('get_all_direct_messages', { recieverId, page })
      .receive('ok', (data) => {
        dispatch({ type: Constants.ADD_DIRECT_MESSAGES, data: data.messages });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  send:(channel, data, callback) => {
    return dispatch => {
      channel.push('create_direct_message', data)
      .receive('ok', (data) => {
        dispatch({ type: Constants.CREATE_DIRECT_MESSAGE, data: data.message });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  read:(channel, senderId, callback) => {
    return dispatch => {
      channel.push('set_read_direct_messages', { senderId })
      .receive('ok', (data) => {
        dispatch({ type: Constants.READ_DIRECT_MESSAGES, data: data.count });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  last:(channel, callback) => {
    return dispatch => {
      channel.push('get_last_messages')
      .receive('ok', (data) => {
        dispatch({ type: Constants.LAST_DIRECT_MESSAGES, data: data.messages });
        if(callback) callback();
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
  clearMessages:() => {
    return dispatch => {
      dispatch({ type: Constants.CLEAR_DIRECT_MESSAGES });
    }
  },
  removeCurrentUser:() => {
    return dispatch => {
      dispatch({ type: Constants.SET_DIRECT_MESSAGE_USER, id: null });
    }
  }
}

export default Actions;
