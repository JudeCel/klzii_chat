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
  shouldAddToAvatar(avatar, type, index, face) {
    if(index < 0) {
      return;
    }

    if(face) {
      avatar.image(`/images/avatar/${type}_${this.pickFace(index, this.props.member.online)}.svg`, 0, 0, 152, 140);
    }
    else {
      avatar.image(`/images/avatar/${type}_${this.padToTwo(index)}.svg`, 0, 0, 152, 140);
    }
  },
  componentDidMount() {
    const { id, username, avatarData, colour, online } = this.props.member;
    const { base, face, body, hair, desk, head } = avatarData;

    let avatar = Snap('#' + this.pickId());
    if(this.shouldClearPrevious) {
      avatar.clear();
      this.shouldClearPrevious = false;
    }

    this.shouldAddToAvatar(avatar, 'base', base);
    this.shouldAddToAvatar(avatar, 'face', face, true);
    this.shouldAddToAvatar(avatar, 'body', body);
    this.shouldAddToAvatar(avatar, 'hair', hair);
    this.shouldAddToAvatar(avatar, 'desk', desk);
    this.shouldAddToAvatar(avatar, 'head', head);

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
