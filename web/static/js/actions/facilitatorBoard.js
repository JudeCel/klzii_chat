import Constants from '../constants';

const Actions = {
  saveBoard(dispatch, data) {
    dispatch({ type: Constants.SAVE_FACILITATOR_BOARD, data: data });
  }
}

export default Actions;
