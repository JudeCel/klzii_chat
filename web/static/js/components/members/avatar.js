import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import SVG                from 'svgjs';
import mixins             from '../../mixins';
import MemberActions      from '../../actions/member';

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
      if(this.props.removeAnim) {
        let image = avatar.image(`/images/avatar/${type}_${this.pickFace(index, this.props.member.online)}.svg`, 0, 0, 152, 140);
        image.addClass('svg-avatar-element');
      }
      else {
        const startPos = 6*152;
        let image = avatar.image(`/images/avatar/${type}_${this.pickFace(index, this.props.member.online)}_anim.svg`, 0, 0, startPos, 140);
        image.addClass(`svg-avatar-element emotion-avatar-${index}`);
      }
    }
    else {
      let image = avatar.image(`/images/avatar/${type}_${this.padToTwo(index)}.svg`, 0, 0, 152, 140);
      image.addClass('svg-avatar-element');
    }
  },
  shouldAddObserverAvatar(avatar) {
    let image = avatar.image(`/images/observer.png`, 10, 10, 123, 80);
    image.addClass('svg-avatar-element');
  },
  getSVGStyle() {
    return {
      'maxWidth': this.boxWidth + "px",
      'maxHeight': this.boxHeight + "px"
    }
  },
  findAvatar() {
    let avatar = SVG(this.pickId());
    let boxSize = "0 0 " + this.boxWidth + " " + this.boxHeight;
    avatar.attr({viewBox: boxSize, preserveAspectRatio: "xMidYMid meet"});
    return avatar;
  },
  clearAvatar(avatar) {
    if(this.shouldClearPrevious) {
      avatar.clear();
      this.shouldClearPrevious = false;
    }
  },
  drawAvatar(avatar) {
    const { sessionTopicId, member, isDirectMessage } = this.props;
    const defaultAvatarFace = 5;
    if (member.role != "observer") {
      const { base, face, body, hair, desk, head } = this.avatarDataBySessionContext(member.avatarData, member.sessionTopicContext, sessionTopicId);
      let avatarFace = isDirectMessage ? defaultAvatarFace : face;
      let showFace = !isDirectMessage;
      this.shouldAddToAvatar(avatar, 'base', base);
      this.shouldAddToAvatar(avatar, 'face', avatarFace, showFace);
      this.shouldAddToAvatar(avatar, 'body', body);
      this.shouldAddToAvatar(avatar, 'hair', hair);
      this.shouldAddToAvatar(avatar, 'desk', desk);
      this.shouldAddToAvatar(avatar, 'head', head);
    } else {
      this.shouldAddObserverAvatar(avatar);
    }
  },
  shakeElement(el, member) {
    const { dispatch } = this.props;
    let count = 3;
    function anim1() {
      count--;
      if (count > 0) {
        el.animate({transform: 'r0.5,150,-20'}, 20, anim2);
      } else if (member) {
        dispatch(MemberActions.stopAnimation(member));
      }
    }
    function anim2() {
      el.animate({transform: 'r0,0,0'}, 20, anim3);
    }
    function anim3() {
      el.animate({transform: 'r-0.5,-150,20'}, 20, anim4);
    }
    function anim4() {
      el.animate({transform: 'r0,0,0'}, 20, anim1);
    }
    anim1();
  },
  drawLabelAndText(avatar) {
    const { username, colour, currentTopic, online, animate } = this.props.member;
    var el1 = avatar.rect(100, 20, 1, 1).attr({fill: colour, x: 25, y: 125}).addClass('svg-avatar-label');
    var el2 = avatar.text(username).attr({fill: '#fff', 'font-size': '75%', 'text-anchor': 'middle', x: 76, y: 138}).addClass('svg-avatar-label');
    if(currentTopic && online) {
      avatar.text(currentTopic.name).attr({fill: '#000', 'font-size': '75%', 'text-anchor': 'middle', x: 76, y: 158}).addClass('svg-avatar-label svg-avatar-topic');
    }
    if (animate) {
       this.shakeElement(el1, this.props.member);
       this.shakeElement(el2);
    }
  },
  componentDidMount() {
    const { avatarData, username, sessionTopicContext, currentTopic } = this.props.member;
    let avatar = this.findAvatar();
    this.clearAvatar(avatar);
    this.drawAvatar(avatar);
    this.drawLabelAndText(avatar);
    this.previousData = { avatarData, username, sessionTopicContext, currentTopic };
  },
  shouldComponentUpdate(nextProps) {
    if(this.previousData) {
      let avatarData = JSON.stringify(this.previousData.avatarData) != JSON.stringify(nextProps.member.avatarData);
      let sessionTopicContext = JSON.stringify(this.previousData.sessionTopicContext) != JSON.stringify(nextProps.member.sessionTopicContext);
      let username = this.previousData.username != nextProps.member.username;
      let currentTopic = this.previousData.currentTopic != nextProps.member.currentTopic;
      let willUpdate = (username || avatarData || sessionTopicContext || currentTopic);
      return willUpdate;
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
  componentWillMount() {
    this.boxWidth = 150;
    this.boxHeight = 160;
  },
  render() {
    const { username, colour, currentTopic, online, animate } = this.props.member;

    return (
      <svg id={ this.pickId() } className='svg-avatar' style={ this.getSVGStyle() }/>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    sessionTopicId: state.sessionTopic.current.id,
    utilityWindow: state.utility.window
  }
};

export default connect(mapStateToProps, null, null, { pure: false })(Avatar);
