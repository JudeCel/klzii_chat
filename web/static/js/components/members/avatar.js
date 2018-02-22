import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import SVG                from 'svgjs';
import mixins             from '../../mixins';
import MemberActions      from '../../actions/member';
import _                  from 'lodash';

const Avatar = React.createClass({
  mixins: [mixins.helpers],
  getInitialState() {
    return {
      boxWidth: 150,
      boxHeight: 160,
      currentData: {}
    };
  },
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
        let image = avatar.image(`/images/avatar/${type}_${this.pickFace(index, this.props.member.online)}.svg`, 152, 140).attr({x: 0, y: 0});
        image.addClass('svg-avatar-element');
      }
      else {
        const startPos = 6*152;
        let image = avatar.image(`/images/avatar/${type}_${this.pickFace(index, this.props.member.online)}_anim.svg`, startPos, 140).attr({x: 0, y: 0});
        image.addClass(`svg-avatar-element emotion-avatar-${index}`);
      }
    }
    else {
      let image = avatar.image(`/images/avatar/${type}_${this.padToTwo(index)}.svg`, 152, 140).attr({x: 0, y: 0});
      image.addClass('svg-avatar-element');
    }
  },
  shouldAddObserverAvatar(avatar) {
    let image = avatar.image(`/images/observer.png`, 123, 80).attr({x: 10, y: 10});
    image.addClass('svg-avatar-element');
  },
  getSVGStyle() {
    return {
      'maxWidth': this.state.boxWidth + "px",
      'maxHeight': this.state.boxHeight + "px"
    }
  },
  findAvatar() {
    let avatar = SVG(this.pickId());
    let boxSize = "0 0 " + this.state.boxWidth + " " + this.state.boxHeight;
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
      el
      .animate(20, '>', 100).rotate(5, '50%', '50%')
      .animate(20, '>', 100).rotate(-5, '50%', '50%')
      .animate(20, '>', 100).rotate(0, '50%', '50%')
      if (member) {
        dispatch(MemberActions.stopAnimation(member));
      }
  },
  drawLabelAndText(avatar) {
    const { username, colour, currentTopic, online, animate } = this.props.member;
    var el1 = avatar.rect(100, 20).attr({fill: colour, x: 25, y: 125}).addClass('svg-avatar-label');
    var el2 = avatar.text(username).attr({fill: '#fff', 'font-size': '75%', 'text-anchor': 'middle', x: 76, y: 138}).addClass('svg-avatar-label');
    if(currentTopic && currentTopic.name && online) {
      avatar.text(currentTopic.name).attr({fill: '#000', 'font-size': '75%', 'text-anchor': 'middle', x: 76, y: 158}).addClass('svg-avatar-label svg-avatar-topic');
    }
    if (animate) {
       this.shakeElement(avatar, this.props.member);
    }
  },
  componentDidMount() {
    const { avatarData, username, sessionTopicContext, currentTopic } = this.props.member;
    if (_.isEmpty(avatarData)) {
      return;
    }
    let avatar = this.findAvatar();
    this.clearAvatar(avatar);
    this.drawAvatar(avatar);
    this.drawLabelAndText(avatar);
    this.setState({currentData: { avatarData, username, sessionTopicContext, currentTopic }});
  },
  shouldComponentUpdate(nextProps) {
    let avatarData = JSON.stringify(this.state.currentData.avatarData) != JSON.stringify(nextProps.member.avatarData);
    let sessionTopicContext = JSON.stringify(this.state.currentData.sessionTopicContext) != JSON.stringify(nextProps.member.sessionTopicContext);
    let username = this.state.currentData.username != nextProps.member.username;
    let currentTopic = this.state.currentData.currentTopic != nextProps.member.currentTopic;
    let willUpdate = (username || avatarData || sessionTopicContext || currentTopic);

    return willUpdate;
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
