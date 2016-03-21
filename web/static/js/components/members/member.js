import React, {PropTypes}       from 'react';
import Avatar from './avatar.js'

const Member = React.createClass({
  render() {
    const { member, isEven } = this.props;
    return(
      <div key={ member.id } className='col-xs-3'>
        <Avatar member={ member } isEven={ isEven } />
      </div>
    )
  }
});

export default Member;
