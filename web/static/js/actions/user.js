import Constants            from '../constants';
import request              from 'superagent';
import NotificationActions  from './notifications';

const USER_API_PATH = '/api/user'

const Actions = {
    changePassword:(dashbaordUrl, jwt, data) => {
        return dispatch => {
            request
                .put(getUserApi(dashbaordUrl))
                .set('Authorization', jwt)
                .send({ password: data.password, repassword: data.repassword })
                .end(function(error, result) {
                    if(error) {
                        NotificationActions.showErrorNotification(dispatch, error);
                    } else {
                        let resultText = JSON.parse(result.text);
                        if (resultText.error) {
                            NotificationActions.showErrorNotification(dispatch, resultText);
                        } else {
                            dispatch({ type: Constants.MODAL_POST_DATA_DONE_AND_CLOSE });
                        }
                    }
                });
        }
  },
    getUser:(dashbaordUrl, jwt) => {
        return dispatch => {
            request
                .get(getUserApi(dashbaordUrl))
                .set('Authorization', jwt)
                .end(function(error, result) {
                    if(error) {
                    NotificationActions.showErrorNotification(dispatch, error);
                    } else {
                        var contactDetails = JSON.parse(result.text);
                        dispatch({ type: Constants.SET_CONTACT_DETAILS, contactDetails: contactDetails.accountUser });
                    }
                });
        }
    },
    postUser:(dashbaordUrl, jwt, data) => {
        return dispatch => {
            request
                .post(getUserApi(dashbaordUrl))
                .set('Authorization', jwt)
                .send(data)
                .end(function(error, res) {
                    if (error) {
                        NotificationActions.showErrorNotification(dispatch, error);
                    } else {
                        let result = JSON.parse(res.text);
                        if (result.error) {
                            NotificationActions.showErrorNotification(dispatch, result.error);
                        } else {
                            dispatch({ type: Constants.SET_CONTACT_DETAILS, contactDetails: result.user });
                            dispatch({ type: Constants.MODAL_POST_DATA_DONE_AND_CLOSE });
                        }
                    }
                });
        }
    }
}

function getUserApi(mainUrl) {
    return mainUrl + USER_API_PATH;
}

export default Actions;
