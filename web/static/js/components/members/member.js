import React, {PropTypes} from 'react';
import Avatar             from './avatar.js';

const Member = React.createClass({
  render() {
    return (
      <Avatar member={ this.props.member } />
    )
  }
});

export default Member;
