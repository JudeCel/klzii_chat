import Constants from '../constants';
import request   from 'superagent';


const Actions = {
  video:(files, userId, topicId) =>{
    return (dispatch) => {
      let csrf_token = localStorage.getItem("csrf_token");

      let req = request.post('/upload');
      req.set('X-CSRF-Token', csrf_token);
      req.attach("userId", userId)
      req.attach("topicId", topicId)

      files.forEach((file)=> {
        req.attach("file", file);
      });
      req.end((e, r) =>{
        console.log(e);
      });
    }
  }
}


export default Actions;
