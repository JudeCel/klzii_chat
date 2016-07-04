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
  // subscribeDirectMessageEvents:(channel) => {
  //   return dispatch => {
  //     channel.on('new_direct_message', (data) =>{
  //       return dispatch({ type: Constants.NEW_DIRECT_MESSAGE, data: data });
  //     });
  //   }
  // },
  enablePinboard:(channel) => {
    return dispatch => {
      channel.push('enable_pinboard')
      .receive('ok', (data) => {
      }).receive('error', (data) => {
        dispatch(_errorData(data));
      });
    }
  },
}

export default Actions;
