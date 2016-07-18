import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';

const Links = React.createClass({
  mixins: [mixins.validations],
  logout_redirect(){
    if (this.props.currentUser.logout_path) {
      window.location.href = this.props.currentUser.logout_path
    }
  },
  render() {
    const { colours } = this.props;
    const style = {
      backgroundColor: colours.headerButton
    };

    console.log(this.hasPermission(['can_redirect', 'logout']));
    if (this.hasPermission(['can_redirect', 'logout'])){
      return(
        <li style={ style }>
          <i className='icon-power' onClick={this.logout_redirect}/>
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
