import React, {PropTypes}   from 'react';
import Snap                 from 'snapsvg';
import Member               from './member.js'

const Avatar = React.createClass({
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  pickFace(face, online) {
    if(online) {
      return this.padToTwo(face);
    }
    else {
      return 'offline';
    }
  },
  pickId() {
    let { specificId, member } = this.props;
    specificId = specificId || 'avatar';
    return `${specificId}-${member.id}`
  },
  componentDidMount() {
    function randomNumber() {
      return Math.floor(Math.random() * 4);
    }

    const { colour } = this.props;
    const { id, username, avatarData, online, edit } = this.props.member;
    const { base, face, body, hair, desk } = edit && avatarData
      ? avatarData
      : { base: 0, face: randomNumber(), body: randomNumber(), hair: randomNumber(), desk: randomNumber() };

    let avatar = Snap('#' + this.pickId());
    Snap.load(`/images/avatar/base_${this.padToTwo(base)}.svg`, (baseSnap) => {
      Snap.load(`/images/avatar/face_${this.pickFace(face, online)}.svg`, (faceSnap) => {
        Snap.load(`/images/avatar/body_${this.padToTwo(body)}.svg`, (bodySnap) => {
          Snap.load(`/images/avatar/hair_${this.padToTwo(hair)}.svg`, (hairSnap) => {
            Snap.load(`/images/avatar/desk_${this.padToTwo(desk)}.svg`, (deskSnap) => {
              avatar.rect(25, 128, 100, 20, 1, 1).attr({fill: colour});
              avatar.text(50, 141, username).attr({fill: '#fff', "font-size": "75%"});
              avatar.rect(30, 133, 90, 3, 5, 5).attr({fill: '#ccc', opacity: 0.2});

              avatar.append(baseSnap);
              avatar.append(faceSnap);
              avatar.append(bodySnap);
              avatar.append(hairSnap);
              avatar.append(deskSnap);
              console.log(avatarData);
              this.previousAvatarData = avatarData;
            });
          });
        });
      });
    });
  },
  componentWillReceiveProps(props) {
    let avatar = Snap('#' + this.pickId());
    console.log(this.previousAvatarData, props.member.avatarData);
    if(avatar && this.props.member.avatarData != this.previousAvatarData) {
      avatar.clear();
      this.componentDidMount();
    }
  },
  render() {
    return (
      <svg id={ this.pickId() } className='avatar' width='150px'>

      </svg>
    )
  }
})

export default Avatar;
