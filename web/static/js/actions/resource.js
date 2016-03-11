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
  upload:(files, type, userid, topicId) =>{
    return (dispatch) => {

      let csrf_token = localStorage.getItem("csrf_token");
      let req = request.post('/upload');
      req.set('X-CSRF-Token', csrf_token);

      files.map((file)=> {
        req.attach("file", file);
        req.field("userId", userid);
        req.field("topicId", topicId);
        req.field("type", type);
        req.field("scope", "collage");
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
