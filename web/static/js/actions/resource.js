import Constants from '../constants';
import request   from 'superagent';


const Actions = {
  subscribeEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_MESSAGES_EVENTS});
      channel.on("resources", (resp) =>{
        dispatch({ type: Constants.SET_MESSAGES_EVENTS});
        return new_message(dispatch, resp);
      });
    }
  },
  upload:(type, files, userId, topicId) =>{
    return (dispatch) => {
      let csrf_token = localStorage.getItem("csrf_token");
      let req = request.post(`/upload/${type}/${userId}/${topicId}`);
      req.set('X-CSRF-Token', csrf_token);

      files.forEach((file)=> {
        req.attach("file", file);
      });

      req.end((e, r) =>{
        console.log(r);
      });
    }
  },
  get:(channel, type) => {
    return dispatch => {
      dispatch({ type: Constants.GET_RESOURCE});
      channel.push("resources", {type: type}).receive('ok', (resp) =>{
        switch (type) {
          case "video":

            break;
          default:

        }
      })
    }
  }
}


export default Actions;
