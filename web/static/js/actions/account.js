import Constants from '../constants';
import request   from 'superagent';
import NotificationActions from './notifications';

const ACCOUNT_API_PATH = '/api/account';

const Actions = {
    createNewUser:(dashboardUrl, jwt, accountName) => {
    return dispatch => {
      request
        .post(getAccountApiUrl(dashboardUrl))
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

function getAccountApiUrl(mainUrl) {
    return mainUrl + ACCOUNT_API_PATH;
}

export default Actions;
