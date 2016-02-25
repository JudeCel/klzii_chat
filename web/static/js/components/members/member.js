import React, {PropTypes}       from 'react';

const Member =  React.createClass({
  render() {
    const { username, role, id, online } = this.props.member;
    return (
      <div key={ id }>
        Name: { username }
        <br />
        Role: { role }
        <br />
        Online: {`${online}`}
      </div>
    );
  }
})
export default Member;
