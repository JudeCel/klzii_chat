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
  }
}

export default Actions;
