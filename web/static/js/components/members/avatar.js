import React, {PropTypes}   from 'react';
import Member               from './member.js'

const Avatar =  React.createClass({
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  render() {
    const [base_number, face_number, body_number, hair_number, desk_number] = this.props.avatar_info.split(":")
    return (
      <div className="combined-avatar">
        <img src={`/images/avatar/base_${this.padToTwo(base_number)}.svg`} />
        <img src={`/images/avatar/face_${this.padToTwo(face_number)}.svg`} />
        <img src={`/images/avatar/body_${this.padToTwo(body_number)}.svg`} />
        <img src={`/images/avatar/hair_${this.padToTwo(hair_number)}.svg`} />
        <img src={`/images/avatar/desk_${this.padToTwo(desk_number)}.svg`} />
      </div>
    )
  }
})

export default Avatar;
