import React            from 'react';
import { connect }      from 'react-redux';
import { Modal }        from 'react-bootstrap';
import mixins           from '../../../mixins';
import Actions          from '../../../actions/user';
import MyDetailsTextBox from './myDetailsTextBox';
import { Form }         from 'formsy-react';
import ReactTelInput    from 'react-telephone-input';

const ContactDetails = React.createClass({
  mixins: [mixins.modalWindows],
  getInitialState() {
    return {
      canSubmit: false
    }
  },
  componentWillReceiveProps(nextProps) {
    if (nextProps.contactDetails) {
      const { contactDetails } = nextProps;
      this.setState({
        firstName: contactDetails.firstName,
        lastName: contactDetails.lastName,
        email: contactDetails.email,
        postalAddress: contactDetails.postalAddress,
        city: contactDetails.city,
        state: contactDetails.state,
        postCode: contactDetails.postCode,
        country: contactDetails.country,
        companyName: contactDetails.companyName,
        gender: contactDetails.gender,
        landlineNumber: contactDetails.landlineNumber,
        landlineNumberCountryData: contactDetails.landlineNumberCountryData,
        mobile: contactDetails.mobile
      });
    }
  },
  getContactDetailValue(contactDetail) {
    if (contactDetail) {
      return contactDetail;
    }

    return "";
  },
  setFirstName(event) {
    this.setState({ firstName: event.currentTarget.value});
  },
  setLastName(event) {
    this.setState({ lastName: event.target.value});
  },
  setEmail(event) {
    this.setState({ email: event.target.value});
  },
  setGender(event) {
    this.setState({ gender: event.target.value});
  },
  setMobileNumber(telNumber, selectedCountry) {
    if(this.isContainingTelNumber(telNumber, selectedCountry.dialCode)){
      this.setState({ mobile: telNumber });
    }
  },
  setLandlineNumber(telNumber, selectedCountry) {
    if(this.isContainingTelNumber(telNumber, selectedCountry.dialCode)) {
      let landlineNumberCountryData = {
        name: selectedCountry.name,
        iso2: selectedCountry.iso2,
        dialCode: selectedCountry.dialCode
      };

      this.setState({ landlineNumberCountryData:  landlineNumberCountryData });
      this.setState({ landlineNumber:  telNumber });
    }
  },
  isContainingTelNumber(telNumber, dialCode) {
    return telNumber.length > dialCode
  },
  setPostalAddress(event) {
    this.setState({ postalAddress: event.target.value});
  },
  setCity(event) {
    this.setState({ city: event.target.value});
  },
  setContactDetailsState(event) {
    this.setState({ state: event.target.value});
  },
  setPostcode(event) {
    this.setState({ postCode: event.target.value});
  },
  setCountry(event) {
    this.setState({ country: event.target.value});
  },
  setCompanyName(event) {
    this.setState({ companyName: event.target.value});
  },
  updateContactDetails() {
      const { dispatch, jwtToken, resourcesConf } = this.props;
      let contactDetails = {
        firstName: this.state.firstName,
        lastName: this.state.lastName,
        email: this.state.email,
        postalAddress: this.state.postalAddress,
        city: this.state.city,
        state: this.state.state,
        postCode: this.state.postCode,
        country: this.state.country,
        companyName: this.state.companyName,
        gender: this.state.gender,
        landlineNumber: this.state.landlineNumber,
        landlineNumberCountryData: this.state.landlineNumberCountryData,
        mobile: this.state.mobile
      };

      dispatch(Actions.postUser(resourcesConf.dashboard_url, jwtToken, contactDetails));
  },
  enableButton() {
    this.setState({ canSubmit: true });
  },
  disableButton() {
    this.setState({ canSubmit: false });
  },
  render() {
    let show = this.showSpecificModal('contactDetails');
    if(show && this.props.contactDetails) {

      return (
        <Modal id="contact-details-modal" dialogClassName='border-red modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Contact Details</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <Form className='row contact-details-fields' onValid={ this.enableButton } onInvalid={ this.disableButton }>
              <div className="col-xs-12">
                <div className="col-md-6">
                  <MyDetailsTextBox name="firstName" type="text" value={ this.state.firstName } label="First name" placeholder="First name" inputId="firstName" onBlur={ this.setFirstName } required/>
                  <MyDetailsTextBox name="lastName" type="text" value={ this.state.lastName } label="Last name" placeholder="Last name" inputId="lastName" onBlur={ this.setLastName } required/>
                  <MyDetailsTextBox name="email" type="email" value={ this.state.email } label="Email" placeholder="Email" inputId="email" onBlur={ this.setEmail } validations="isEmail" validationError="This is not a valid email" required/>
                  <div className="form-group radio-gender-group">
                    <label className="control-label col-md-2 text-no-bold" htmlFor="gender">Gender: </label>
                    <div className="col-md-8 radio-group">
                      <div>
                        <input checked={ this.state.gender === "male" } value="male" id="genderMale" type="radio" name="radio_gender" className="text-vertical-middle" onChange={ this.setGender } />
                        <label className="gender-radio-label" htmlFor="genderMale">Male</label>
                        <input checked={ this.state.gender === "female" } value="female" id="genderFemale" type="radio" name="radio_gender" className="text-vertical-middle" onChange={ this.setGender } />
                        <label className="gender-radio-label" htmlFor="genderFemale">Female</label>
                        <input checked={ this.state.gender === "neither" } value="neither" id="genderNeither" type="radio" name="radio_gender" className="text-vertical-middle" onChange={ this.setGender } />
                        <label className="gender-radio-label" htmlFor="genderNeither">Neither</label>
                      </div>
                    </div>
                  </div>
                  <div className="form-group">
                    <label className="control-label col-md-4 text-no-bold" htmlFor="mobile">Mobile number </label>
                    <ReactTelInput initialValue={ this.state.mobile } id="mobile" defaultCountry="au" flagsImagePath='/images/flags.png' autoFormat={ false } onBlur={ this.setMobileNumber } />
                  </div>
                  <div className="form-group">
                    <label className="control-label col-md-6 text-no-bold" htmlFor="landlineNumber">Landline number </label>
                    <ReactTelInput initialValue={ this.state.landlineNumber } id="landlineNumber" defaultCountry="au" flagsImagePath='/images/flags.png' autoFormat={ false } onBlur={ this.setLandlineNumber } />
                  </div>
                </div>

                <div className="col-md-6">
                  <MyDetailsTextBox name="postalAddress" type="text" value={ this.getContactDetailValue(this.state.postalAddress) } label="Postal address" placeholder="Postal address" inputId="postalAddress" onBlur={ this.setPostalAddress }/>
                  <MyDetailsTextBox name="city" type="text" value={ this.getContactDetailValue(this.state.city) } label="City" placeholder="City" inputId="city" onBlur={ this.setCity } />
                  <MyDetailsTextBox name="state" type="text" value={ this.getContactDetailValue(this.state.state) } label="State" placeholder="State" inputId="state" onBlur={ this.setContactDetailsState } />
                  <MyDetailsTextBox name="postcode" type="text" value={ this.getContactDetailValue(this.state.postCode) } label="Postcode" placeholder="Postcode" inputId="postcode" onBlur={ this.setPostcode } />
                  <MyDetailsTextBox name="country" type="text" value={ this.getContactDetailValue(this.state.country) } label="Country" placeholder="Country" inputId="country"onBlur={ this.setCountry } />
                  <MyDetailsTextBox name="companyName" type="text" value={ this.getContactDetailValue(this.state.companyName) } label="Company name" placeholder="Company name" inputId="companyName" onBlur={ this.setCompanyName } />
                </div>

              </div>
            </Form>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Cancel</button>
            <button className="btn btn-standart btn-green btn-padding-24 pull-right" disabled={ !this.state.canSubmit } onClick={ this.updateContactDetails }>Update</button>
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
    resourcesConf: state.chat.resourcesConf,
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours,
    contactDetails: state.members.currentUser.contactDetails
  }
};

export default connect(mapStateToProps)(ContactDetails);
