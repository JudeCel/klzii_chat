import React       from 'react';
import { connect } from 'react-redux';
import { Modal }   from 'react-bootstrap';
import mixins      from '../../mixins';
import Actions     from '../../actions/account'

const CreateNewAccount = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
      return { newAccountName: "" };
  },
  setNewAccountName(event) {
      this.setState({ newAccountName: event.target.value });
  },
  createNewAccountConfirm() {
      const { dispatch, jwtToken } = this.props;
      dispatch(Actions.createNewUser(jwtToken, this.state.newAccountName));
  },
  render() {
    let show = this.showSpecificModal('createNewAccount');

    if(show) {
      return (
        <Modal dialogClassName='modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Create New Account</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className="form-group">
              <label htmlFor="newAccountName">Select name of your account</label>
              <input type="text" className="form-control center-block " name="newAccountName" id="newAccountName" placeholder="" onBlur={ this.setNewAccountName } />
            </div>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Cancel</button>
            <button onClick={ this.createNewAccountConfirm } className="btn btn-standart btn-green btn-padding-24 pull-right">Done</button>
          </Modal.Footer>
        </Modal>
      )
    }
    else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
    jwtToken: state.chat.jwtToken
  }
};

export default connect(mapStateToProps)(CreateNewAccount);
