import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Snap               from 'snapsvg';
import mixins             from '../../mixins';

const Avatar = React.createClass({
  mixins: [mixins.helpers],
  padToTwo(number) {
    if (number<=99) { number = ("0"+number).slice(-2); }
    return number;
  },
  pickFace(face, online) {
    if(online) {
      return this.padToTwo(face);
    }
    else {
      return this.padToTwo(6);
    }
  },
  pickId() {
    let { specificId, member } = this.props;
    specificId = specificId || 'avatar';
    return `${specificId}-${member.id}`;
  },
  shouldAddToAvatar(avatar, type, index, face) {
    if(index < 0) {
      return;
    }

    if(face) {
      const startPos = 6*152;
      let image = avatar.image(`/images/avatar/${type}_${this.pickFace(index, this.props.member.online)}_anim.svg`, 0, 0, startPos, 140);
      image.addClass(`emotion-avatar-${index}`);
    }
    else {
      avatar.image(`/images/avatar/${type}_${this.padToTwo(index)}.svg`, 0, 0, 152, 140);
    }
  },
  findAvatar() {
    return Snap('#' + this.pickId());
  },
  clearAvatar(avatar) {
    if(this.shouldClearPrevious) {
      avatar.clear();
      this.shouldClearPrevious = false;
    }
  },
  drawAvatar(avatar) {
    const { sessionTopicId, member } = this.props;
    const { base, face, body, hair, desk, head } = this.avatarDataBySessionContext(member.avatarData, member.sessionTopicContext, sessionTopicId);
    this.shouldAddToAvatar(avatar, 'base', base);
    this.shouldAddToAvatar(avatar, 'face', face, true);
    this.shouldAddToAvatar(avatar, 'body', body);
    this.shouldAddToAvatar(avatar, 'hair', hair);
    this.shouldAddToAvatar(avatar, 'desk', desk);
    this.shouldAddToAvatar(avatar, 'head', head);
  },
  drawLabelAndText(avatar) {
    const { username, colour } = this.props.member;
    avatar.rect(25, 125, 100, 20, 1, 1).attr({fill: colour});
    avatar.text(76, 138, username).attr({fill: '#fff', 'font-size': '75%', 'text-anchor': 'middle'});
    avatar.rect(30, 130, 90, 3, 5, 5).attr({fill: '#ccc', opacity: 0.2});
  },
  componentDidMount() {
    const { avatarData, username, sessionTopicContext } = this.props.member;

    let avatar = this.findAvatar();
    this.clearAvatar(avatar);
    this.drawAvatar(avatar);
    this.drawLabelAndText(avatar);

    this.previousData = { avatarData, username, sessionTopicContext };
  },
  shouldComponentUpdate(nextProps) {
    if(this.previousData) {
      let avatarData = JSON.stringify(this.previousData.avatarData) != JSON.stringify(nextProps.member.avatarData);
      let sessionTopicContext = JSON.stringify(this.previousData.sessionTopicContext) != JSON.stringify(nextProps.member.sessionTopicContext);
      let username = this.previousData.username != nextProps.member.username;
      return(!(username && avatarData && sessionTopicContext));
    }
    else {
      return true;
    }
  },
  componentDidUpdate() {
    let avatar = this.findAvatar();

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

const mapStateToProps = (state) => {
  return {
    sessionTopicId: state.sessionTopic.current.id
  }
};

export default connect(mapStateToProps, null, null, { pure: false })(Avatar);
