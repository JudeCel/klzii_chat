import Constants from '../constants';
import request   from 'superagent';


const Actions = {
  video:(files, userId, topicId) =>{
    return (dispatch) => {
      let csrf_token = localStorage.getItem("csrf_token");
      let req = request.post(`/upload/${userId}/${topicId}`);
      req.set('X-CSRF-Token', csrf_token);

      files.forEach((file)=> {
        req.attach("file", file);
      });

      req.end((e, r) =>{
        console.log(r);
      });
    }
  }
}


export default Actions;
