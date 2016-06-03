import React, {PropTypes} from 'react';
import Avatar             from './avatar.js';

const Member = React.createClass({
  render() {
    const { member, sessionTopicId } = this.props;
    return (
      <Avatar member={ member } sessionTopicId={sessionTopicId}/>
    )
  }
});

export default Member;
