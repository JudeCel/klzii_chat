import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import LogoutLink         from './logout';
import MyDetailsButton    from './myDetails';

const LeaveOrDetails = React.createClass({
  mixins: [mixins.validations, mixins.headerActions],
  leaveButton() {
    return (
      <LogoutLink />
    );
  },
  myDetailsButton() {
    return (
      <MyDetailsButton />
    );
  },
  render() {
    const { currentUser } = this.props;

    return this.isFacilitator(currentUser) ? this.leaveButton() : this.myDetailsButton();
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser
  };
};

export default connect(mapStateToProps)(LeaveOrDetails);
