import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Snap               from 'snapsvg';
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
    var el1 = avatar.rect(25, 125, 100, 20, 1, 1).attr({fill: colour}).addClass('svg-avatar-label');
    var el2 = avatar.text(76, 138, username).attr({fill: '#fff', 'font-size': '75%', 'text-anchor': 'middle'}).addClass('svg-avatar-label');

    if(currentTopic && online) {
      avatar.text(76, 158, currentTopic.name).attr({fill: '#000', 'font-size': '75%', 'text-anchor': 'middle'}).addClass('svg-avatar-label');
    }

    if (animate) {
       this.shakeElement(el1, this.props.member);
       this.shakeElement(el2);
    }
  },
  scaleAvatar(group) {
    if(group) {
      let minWidth = 1200;
      const { width } = this.props.utilityWindow;

      if(width  < minWidth) {
        group.transform(`scale(${width / minWidth})`);
      }
      else {
        group.transform(`scale(1)`);
      }
    }
  },
  componentDidMount() {
    const { avatarData, username, sessionTopicContext, currentTopic } = this.props.member;

    let avatar = this.findAvatar();
    this.clearAvatar(avatar);
    this.drawAvatar(avatar);
    this.drawLabelAndText(avatar);

    let array = [...avatar.selectAll('image'), ...avatar.selectAll('rect'), ...avatar.selectAll('text')]
    let group = avatar.group(...array);
    if(!this.props.specificId) {
      this.scaleAvatar(group);
    }

    this.previousData = { avatarData, username, sessionTopicContext, currentTopic };
  },
  shouldComponentUpdate(nextProps) {
    if(this.previousData) {
      let avatarData = JSON.stringify(this.previousData.avatarData) != JSON.stringify(nextProps.member.avatarData);
      let sessionTopicContext = JSON.stringify(this.previousData.sessionTopicContext) != JSON.stringify(nextProps.member.sessionTopicContext);
      let username = this.previousData.username != nextProps.member.username;
      let currentTopic = this.previousData.currentTopic != nextProps.member.currentTopic;
      let screenChange = JSON.stringify(nextProps.utilityWindow) != JSON.stringify(this.props.utilityWindow);
      return(!(username && avatarData && sessionTopicContext && currentTopic) || screenChange);
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
      <svg id={ this.pickId() } className='svg-avatar' width='150px' height='160px'/>
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
