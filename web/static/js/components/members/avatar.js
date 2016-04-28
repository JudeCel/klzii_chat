import React, {PropTypes} from 'react';
import Snap               from 'snapsvg';
import Member             from './member.js'

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

    const { id, username, avatarData, colour, online, edit } = this.props.member;
    const { base, face, body, hair, desk, head } = avatarData

    let avatar = Snap('#' + this.pickId());
    if(this.shouldClearPrevious) {
      avatar.clear();
      this.shouldClearPrevious = false;
    }
    avatar.image(`/images/avatar/base_${this.padToTwo(base)}.svg`, 0, 0, 152, 140);
    avatar.image(`/images/avatar/face_${this.pickFace(face, online)}.svg`, 0, 0, 152, 140);
    avatar.image(`/images/avatar/body_${this.padToTwo(body)}.svg`, 0, 0, 152, 140);
    avatar.image(`/images/avatar/hair_${this.padToTwo(hair)}.svg`, 0, 0, 152, 140);
    avatar.image(`/images/avatar/desk_${this.padToTwo(desk)}.svg`, 0, 0, 152, 140);
    avatar.image(`/images/avatar/head_${this.padToTwo(head)}.svg`, 0, 0, 152, 140);
    avatar.rect(25, 125, 100, 20, 1, 1).attr({fill: colour});
    avatar.text(76, 138, username).attr({fill: '#fff', "font-size": "75%", "text-anchor": "middle"});
    avatar.rect(30, 130, 90, 3, 5, 5).attr({fill: '#ccc', opacity: 0.2});
    this.previousData = {avatarData, username}
  },
  shouldComponentUpdate(nextProps) {
    if (this.previousData) {
      let AvatarData = JSON.stringify(this.previousData.avatarData) != JSON.stringify(nextProps.member.avatarData);
      let username = this.previousData.username != nextProps.member.username;
      return(!(username && AvatarData))
    }else {
      return true
    }
  },
  componentDidUpdate() {
    let avatar = Snap('#' + this.pickId());
    if(avatar) {
      this.shouldClearPrevious = true;
      this.componentDidMount();
    }
  },
  render() {
    return (
      <svg id={ this.pickId() } width='150px' />
    )
  }
});

export default Avatar;
