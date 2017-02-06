import React            from 'react';
import { connect }      from 'react-redux';
import { Modal }        from 'react-bootstrap';
import mixins           from '../../../mixins';
import Actions          from '../../../actions/user';
import { Form }         from 'formsy-react';

const EmailNotification = React.createClass({
  mixins: [mixins.modalWindows],
  componentWillReceiveProps(nextProps) {
    if (nextProps.contactDetails) {
      const { contactDetails } = nextProps;
      this.setState({ 
        emailNotification: contactDetails.emailNotification
      });
    }
  },
  setEmailNotification(event) {
    this.setState({ emailNotification: event.currentTarget.value});       
  },
  updateEmailNotification() {
    const { dispatch, jwtToken, resourcesConf } = this.props;
    let contactDetails = {
      emailNotification: this.state.emailNotification
    };
    
    dispatch(Actions.postUser(resourcesConf.dashboard_url, jwtToken, contactDetails));
  },
  render() {
    let show = this.showSpecificModal('emailNotification');
    console.log(this.props.contactDetails);

    if(show && this.props.contactDetails) {

      return (
        <Modal id="contact-details-modal" dialogClassName='border-red modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Contact Details</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <Form className='row contact-details-fields'>
              <div className="col-xs-12">

                <div className="form-group">
                  <input checked={ this.state.gender === "male" } value="male" id="genderMale" type="radio" name="radio_gender" className="text-vertical-middle" onChange={ this.setEmailNotification } />
                  <label className="gender-radio-label" htmlFor="genderMale">Male</label>
                  <input checked={ this.state.gender === "female" } value="female" id="genderFemale" type="radio" name="radio_gender" className="text-vertical-middle" onChange={ this.setEmailNotification } />
                  <label className="gender-radio-label" htmlFor="genderFemale">Female</label>
                </div>
                
              </div>
            </Form>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Cancel</button>
            <button className="btn btn-standart btn-green btn-padding-24 pull-right" disabled={ !this.state.canSubmit } onClick={ this.updateEmailNotification }>Save</button>
          </Modal.Footer>
        </Modal>
      )

    } else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    jwtToken: state.chat.jwtToken,
    resourcesConf: state.chat.resourcesConf,
    modalWindows: state.modalWindows,
    contactDetails: state.members.currentUser.contactDetails
  }
};

export default connect(mapStateToProps)(EmailNotification);
