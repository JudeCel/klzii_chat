import React, { PropTypes }           from 'react';
import { connect }                    from 'react-redux';
import mixins                         from '../../mixins';
import Actions                        from '../../actions/user'
import { DropdownButton, MenuItem }   from 'react-bootstrap';
import ContactDetailsModal            from './modals/contactDetails';
import ChangePassowordModal           from './modals/changePassword';
import CreateNewAccountModal          from '../header/modals/createNewAccount';
import EmailNotificationModal          from '../header/modals/emailNotification';

const MyDetails = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations, mixins.headerActions],
  openContactDetailsModal() {
    const { dispatch, jwtToken, resourcesConf } = this.props;
    dispatch(Actions.getUser(resourcesConf.dashboard_url, jwtToken));
    this.openSpecificModal('contactDetails');
  },
  openChangePasswordModal() {
    this.openSpecificModal('changePassword');
  },
  openEmailNotificationModal() {
    this.openSpecificModal('emailNotification');
  },
  openCreateNewAccountModal() {
    this.openSpecificModal('createNewAccount');
  },
  render() {
    if (this.hasPermission(['can_redirect', 'logout'])) {
      return (
        <span>
          <DropdownButton className="my-details-button" title="My Details" id="my-details">
            <MenuItem className="my-details-item" href="#" onClick={this.openContactDetailsModal}>
              Contact Details
              <img className="my-details-image" src="/images/icons/contact_list_red.png" />
            </MenuItem>
            <li role="separator" className="my-details-divider divider"></li>
            <MenuItem className="my-details-item" href="#" onClick={this.openChangePasswordModal}>
              Change Password
              <img className="my-details-image" src="/images/icons/password_green_flat.png" />
            </MenuItem>
            <li role="separator" className="my-details-divider divider"></li>
            <MenuItem className="my-details-item" href="#" onClick={this.openEmailNotificationModal}>
              Email Notification
              <img className="my-details-image" src="/images/icons/email_notification.png" />
            </MenuItem>
            <li role="separator" className="my-details-divider divider"></li>
            <MenuItem className="my-details-item" href="#" onClick={this.openCreateNewAccountModal}>
              Create New Account
              <img className="my-details-image" src="/images/icons/user_plus_grey.png" />
            </MenuItem>
            <li role="separator" className="my-details-divider divider"></li>
            <MenuItem className="my-details-item" href="#" onClick={this.dashboardLogout}>
              Logout
              <img className="my-details-image" src="/images/icons/logout_yellow.png" />
            </MenuItem>
          </DropdownButton>

          <ContactDetailsModal />
          <ChangePassowordModal />
          <CreateNewAccountModal />
          <EmailNotificationModal />
        </span>
      )
    } else {
      return false;
    };
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows,
    jwtToken: state.chat.jwtToken,
    resourcesConf: state.chat.resourcesConf,
  };
};

export default connect(mapStateToProps)(MyDetails);
