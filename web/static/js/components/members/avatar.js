import React, {PropTypes}   from 'react';
import Snap                 from 'snapsvg';
import Member               from './member.js'

const Avatar = React.createClass({
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  pickFace(face_number, online) {
    if(online) {
      return this.padToTwo(face_number);
    }
    else {
      return 'offline';
    }
  },
  componentDidMount() {
    function randomNumber() {
      return Math.floor(Math.random() * 4);
    }

    const { colour } = this.props;
    const { id, username, avatar_info, online } = this.props.member;
    const [base_number, face_number, body_number, hair_number, desk_number] = [0, randomNumber(), randomNumber(), randomNumber(), randomNumber()];
    // avatar_info.split(':');

    let avatar = Snap(`#avatar-${id}`);
    Snap.load(`/images/avatar/base_${this.padToTwo(base_number)}.svg`, (base) => {
      Snap.load(`/images/avatar/face_${this.pickFace(face_number, online)}.svg`, (face) => {
        Snap.load(`/images/avatar/body_${this.padToTwo(body_number)}.svg`, (body) => {
          Snap.load(`/images/avatar/hair_${this.padToTwo(hair_number)}.svg`, (hair) => {
            Snap.load(`/images/avatar/desk_${this.padToTwo(desk_number)}.svg`, (desk) => {
              avatar.rect(25, 128, 100, 20, 1, 1).attr({fill: colour});
              avatar.text(50, 141, username).attr({fill: '#fff', "font-size": "75%"});
              avatar.rect(30, 133, 90, 3, 5, 5).attr({fill: '#ccc', opacity: 0.2});
              base = avatar.append(base);
              face = avatar.append(face);
              body = avatar.append(body);
              hair = avatar.append(hair);
              desk = avatar.append(desk);
            });
          });
        });
      });
    });
  },
  render() {
    return (
      <svg id={`avatar-${this.props.member.id}`} width='150px'>

      </svg>
    )
  }
})

export default Avatar;
