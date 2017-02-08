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
      const { contactDetails: { emailNotification } } = nextProps;
      this.setState({ emailNotification });
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

    if(show && this.props.contactDetails) {

      return (
        <Modal id="contact-details-modal" dialogClassName='border-red modal-section modal-lg' show={ show } onHide={ this.closeAllModals } onEnter={ this.onEnterModal }>
          <Modal.Header>
            <div className='text-center modal-title'>
              <h2>Email Notifications</h2>
            </div>
          </Modal.Header>

          <Modal.Body>
            <Form className='row contact-details-fields'>
              <div className="col-xs-12">

                <div className="form-group radio-notification-group">
                  <p>
                    <input checked={ this.state.emailNotification === "none" } value="none" id="emailNotificationNone" type="radio" name="radio_emailNotification" className="text-vertical-middle" onChange={ this.setEmailNotification } />
                    <label className="emailNotification-radio-label" htmlFor="emailNotificationNone">Don't send any Notifications</label>
                  </p>
                  <p>
                    <input checked={ this.state.emailNotification === "privateMessages" } value="privateMessages" id="emailNotificationPrivateMessages" type="radio" name="radio_emailNotification" className="text-vertical-middle" onChange={ this.setEmailNotification } />
                    <label className="emailNotification-radio-label" htmlFor="emailNotificationPrivateMessages">Send only whenever someone sends me a Private Message</label>
                  </p>
                  <p>
                    <input checked={ this.state.emailNotification === "all" } value="all" id="emailNotificationAll" type="radio" name="radio_emailNotification" className="text-vertical-middle" onChange={ this.setEmailNotification } />
                    <label className="emailNotification-radio-label" htmlFor="emailNotificationAll">Send whenever someone Posts or sends me a Private Message</label>
                  </p>
                </div>
                
              </div>
            </Form>
          </Modal.Body>

          <Modal.Footer>
            <button onClick={ this.closeAllModals } className='btn btn-standart btn-red btn-padding-24 pull-left'>Cancel</button>
            <button className="btn btn-standart btn-green btn-padding-24 pull-right" onClick={ this.updateEmailNotification }>Save</button>
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
    colours: state.chat.session.colours,
    contactDetails: state.members.currentUser.contactDetails
  }
};

export default connect(mapStateToProps)(EmailNotification);
