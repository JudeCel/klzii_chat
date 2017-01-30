import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import mixins from '../../mixins';
import Actions from '../../actions/user'
import { DropdownButton, MenuItem } from 'react-bootstrap';

const MyDetails = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations, mixins.headerActions],
  openContactDetailsModal() {
    // const { jwtToken, dispatch } = this.props;
    // dispatch(Actions.getUser(jwtToken));
    const { jwtToken, dispatch } = this.props;
    dispatch(Actions.getUser(jwtToken));
    this.openSpecificModal('contactDetails');
  },
  openChangePasswordModal() {
    this.openSpecificModal('changePassword');
  },
  openCreateNewAccountModal() {
    this.openSpecificModal('createNewAccount');
  },
  render() {
    if (this.hasPermission(['can_redirect', 'logout'])) {
      return (
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
    jwtToken: state.chat.jwtToken
  };
};

export default connect(mapStateToProps)(MyDetails);
