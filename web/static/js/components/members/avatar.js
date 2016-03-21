import React, {PropTypes}   from 'react';
import Snap                 from 'snapsvg';
import Member               from './member.js'

const Avatar =  React.createClass({
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  componentDidMount() {
    let s = Snap(`#avatar-${this.props.id}`);
    const [base_number, face_number, body_number, hair_number, desk_number] = this.props.avatar_info.split(':');

    Snap.load(`/images/avatar/base_${this.padToTwo(base_number)}.svg`, (base) => {
      Snap.load(`/images/avatar/face_${this.padToTwo(face_number)}.svg`, (face) => {
        Snap.load(`/images/avatar/body_${this.padToTwo(body_number)}.svg`, (body) => {
          Snap.load(`/images/avatar/hair_${this.padToTwo(hair_number)}.svg`, (hair) => {
            Snap.load(`/images/avatar/desk_${this.padToTwo(desk_number)}.svg`, (desk) => {
              s.group(base, face, body, hair, desk);
            });
          });
        });
      });
    });
  },
  render() {
    return (
      <div>
        <svg id={`avatar-${this.props.id}`}>

        </svg>
      </div>
    )
  }
})

export default Avatar;
