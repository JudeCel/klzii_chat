import React, {PropTypes} from 'react';
import Avatar             from './avatar.js';

const Member = React.createClass({
  render() {
    const { member, colour } = this.props;

    return (
      <Avatar member={ member } colour={ colour } />
    )
  }
});

export default Member;
