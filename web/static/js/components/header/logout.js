import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';

const Links = React.createClass({
  mixins: [mixins.validations, mixins.headerActions],
  render() {
    const { colours } = this.props;
    const style = {
      backgroundColor: colours.headerButton
    };
    if (this.hasPermission(['can_redirect', 'logout'])){
      return(
        <li style={ style } onClick={ this.logOut }>
          <span className="log-out">Leave</span>
          <i className='icon-power'/>
        </li>
      )
    }else {
      return false;
    };
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    colours: state.chat.session.colours
  };
};

export default connect(mapStateToProps)(Links);
