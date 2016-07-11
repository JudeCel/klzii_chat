import Constants from '../constants';
import NotificationActions from './notifications';

const Actions = {
  subscribeConsoleEvents: (channel) =>{
    return dispatch => {
      channel.on("console", (console) =>{
        return dispatch({
          type: Constants.SET_CONSOLE,
          console: console
        });
      });
    }
  },
  removeFromConsole: (channel, type) => {
    return dispatch => {
      channel.push('remove_console_element', { type: type })
      .receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    };
  },
  addToConsole: (channel, id) => {
    return dispatch => {
      channel.push('set_console_resource', { id: id })
      .receive('error', (errors) => {
        NotificationActions.showErrorNotification(dispatch, errors);
      });
    };
  }
}

export default Actions;
