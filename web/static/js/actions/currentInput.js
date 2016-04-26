import Constants                          from '../constants';

function update_message(dispatch, data) {
  return dispatch({
    type: Constants.UPDATE_TOPIC_MESSAGE,
    message: data
  });
}

const Actions = {
  changeValue:(value) =>{
    return (dispatch) => {
      dispatch({
        type: Constants.CHANGE_INPUT_VALUE,
        value
      });
    }
  },
  changeEmotion:(emotion) =>{
    return (dispatch) => {
      dispatch({
        type: Constants.SET_INPUT_EMOTION,
        emotion
      });
    }
  }
}


export default Actions;
