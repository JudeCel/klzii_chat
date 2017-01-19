import React       from 'react';
import { connect } from 'react-redux';
import { Modal }   from 'react-bootstrap';
import mixins      from '../../mixins';
import Actions     from '../../actions/user';
import MyDetailsTextBox from '../modals/myDetailsTextBox';

const ContactDetails = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialData() {
    const { dispatch, jwt } = this.props;
    dispatch(Actions.getUser(jwt));
  },
  componentDidMount() {
    // this.getInitialData();
  },
  setFirstName(event) {
    this.setState({ firstName: event.target.value });
  },
  render() {
    let show = this.showSpecificModal('contactDetails');

    if(show) {
      return (
        <Modal dialogClassName='modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Contact Details</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <div className='row contact-details-fields'>
              <div className="col-xs-12">
                <div className="col-md-6">
                  <MyDetailsTextBox label="First name" placeholder="First name" inputId="firstName" onBlur={ this.setFirstName }/>
                  <MyDetailsTextBox label="Last name" placeholder="Last name" inputId="lastName" />
                  <MyDetailsTextBox label="Email" placeholder="Email" inputId="email" />
                  <MyDetailsTextBox label="Mobile number" placeholder="+61 412 345 678" inputId="mobile" />
                  <MyDetailsTextBox label="Landline number" placeholder="+61 412 345 678" inputId="landlineNumber" />
                </div>

                <div className="col-md-6">
                  <MyDetailsTextBox label="Postal address" placeholder="Postal address" inputId="postalAddress" />
                  <MyDetailsTextBox label="City" placeholder="City" inputId="city" />
                  <MyDetailsTextBox label="State" placeholder="State" inputId="state" />
                  <MyDetailsTextBox label="Postcode" placeholder="Postcode" inputId="postcode" />
                  <MyDetailsTextBox label="Country" placeholder="Country" inputId="country" />
                  <MyDetailsTextBox label="Company name" placeholder="Company name" inputId="companyName" />
                </div>
                
              </div>
            </div>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Cancel</button>
            <button className="btn btn-standart btn-green btn-padding-24 pull-right">Done</button>
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
    jwtToken: state.chat.jwtToken,
    modalWindows: state.modalWindows,
    currentUser: state.members.currentUser,
    colours: state.chat.session.colours,
    details: state.resources
  }
};

export default connect(mapStateToProps)(ContactDetails);
