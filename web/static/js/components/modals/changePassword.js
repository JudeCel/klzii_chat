import React       from 'react';
import { connect } from 'react-redux';
import { Modal }   from 'react-bootstrap';
import mixins      from '../../mixins';
import Actions     from '../../actions/user'

const ChangePassword = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
      return {
          password: "",
          repassword: ""
      };
  },
  componentDidMount() {
    console.log("CHANGE PASSWORD MODAL MOUNT!");
  },
  passwordChangeConfirm() {
      const { dispatch, jwtToken } = this.props;
      let password = {
        password: this.state.password,
        repassword: this.state.repassword
      };
      
      dispatch(Actions.changePassword(jwtToken, password));
  },
  setPassword(event) {
    this.setState({ password: event.target.value});    
  },
  setRepassword(event) {
    this.setState({ repassword: event.target.value});    
  },
  render() {
    let show = this.showSpecificModal('changePassword');

    if(show) {
      return (
        <Modal dialogClassName='modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Change Password</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className="form-group">
              <label htmlFor="password">New Password</label>
              <input type="password" className="form-control center-block " name="password" id="password" placeholder="" onBlur={ this.setPassword } />
            </div>

            <div className="form-group">
              <label htmlFor="repassword">Confirm New Password</label>
              <input type="password" className="form-control center-block " name="repassword" id="repassword" placeholder="" onBlur={ this.setRepassword }/>
            </div>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Cancel</button>
            <button onClick={ this.passwordChangeConfirm } className="btn btn-standart btn-green btn-padding-24 pull-right">Done</button>
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

export default connect(mapStateToProps)(ChangePassword);
