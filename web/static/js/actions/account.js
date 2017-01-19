import Constants from '../constants';
import request   from 'superagent';
import NotificationActions from './notifications';

const Actions = {
    createNewUser:(jwt, accountName) => {
    return dispatch => {
      request
        .post('http://insider.focus.com:8080/api/account')
        .set('Authorization', jwt)
        .send({ accountName: accountName })
        .end(function(error, result) {
            if(error) {
                NotificationActions.showErrorNotification(dispatch, error);
            } else {
                let resultText = JSON.parse(result.text)
                if (resultText.error) {
                    NotificationActions.showErrorNotification(dispatch, resultText.error);
                } else {
                    dispatch({ type: Constants.MODAL_POST_DATA_DONE_AND_CLOSE });
                }
            }
        });
    }
  }
}

export default Actions;
