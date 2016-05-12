import Constants from '../constants';
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
  removeFromConsole: (type) => {
    return dispatch => {
      channel.push('remove_console_resource', { type: type });
    };
  },
  addToConsole: (id) => {
    return dispatch => {
      channel.push('set_console_resource', { id: id });
    };
  }
}

export default Actions;
