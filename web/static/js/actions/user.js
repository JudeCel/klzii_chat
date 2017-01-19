import Constants from '../constants';
import request   from 'superagent';
import NotificationActions from './notifications';

const Actions = {
    changePassword:(jwt, data) => {
    return dispatch => {
      request
        .put('http://insider.focus.com:8080/api/user')
        .set('Authorization', jwt)
        .send({ password: data.password, repassword: data.repassword })
        .end(function(error, result) {
            if(error) {
                NotificationActions.showErrorNotification(dispatch, error);
            } else {
                let resultText = JSON.parse(result.text)
                if (resultText.error) {
                    NotificationActions.showErrorNotification(dispatch, resultText);
                } else {
                    dispatch({ type: Constants.MODAL_POST_DATA_DONE_AND_CLOSE });
                }
            }
        });
    }
  },
  getUser:(jwt) => {
      return dispatch => {
          request
            .get('http://insider.focus.com:8080/api/user')
            .set('Authorization', jwt)
            .end(function(error, result) {
                console.log("RESULT: ", result);
                var contactDetails = JSON.parse(result.text);
                console.log("ERROR: ", error);
                // dispatch({ type: "CONTACT_DETAILS", contactDetails: contactDetails });
                dispatch({type: Constants.SET_FILE_RESOURCES, resources: contactDetails });
            });
      }
  }
}

export default Actions;
