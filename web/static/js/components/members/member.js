import React, {PropTypes} from 'react';
import Avatar             from './avatar.js';

const Member = React.createClass({
  render() {
    const { member } = this.props;

    return (
      <Avatar member={ member } />
    )
  }
});

export default Member;
