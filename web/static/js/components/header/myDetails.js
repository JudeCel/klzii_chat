import React, {PropTypes}             from 'react';
import { connect }                    from 'react-redux';
import mixins                         from '../../mixins';
import  { DropdownButton, MenuItem }  from 'react-bootstrap';

const Links = React.createClass({
  mixins: [mixins.validations, mixins.headerActions],
  render() {
    const { colours } = this.props;
    const style = {
      backgroundColor: colours.headerButton
    };
    if (this.hasPermission(['can_redirect', 'logout'])){
      return(
        <DropdownButton className="my-details-button" title="My Details">
              <MenuItem href="#">Contact Details</MenuItem>
              <MenuItem href="#">Change Password</MenuItem>
              <MenuItem href="#">Create New Account</MenuItem>
              <MenuItem href="#">Logout</MenuItem>
        </DropdownButton>
      )
    }else {
      return false;
    };
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser
  };
};

export default connect(mapStateToProps)(Links);
