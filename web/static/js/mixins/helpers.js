const helpers = {
  getConsoleResourceId(type) {
    switch (type) {
      case "link":
        return this.props.console['video_id'];
      case "pinboard":
        return this.props.console[type];
      default:
        return this.props.console[type + '_id'];
    }
  },
  get_session_resource_types(modalName){
    let type = [modalName]
    switch (modalName) {
      case "link":
      case "video":
          type.push("link")
        break;
      default:
        type
    }
    return type
  },
  isOtherItemsActive(except) {
    const { tConsole } = this.props;

    for(var i in tConsole) {
      if(tConsole[i] && i != except) {
        return true;
      }
    }

    return false;
  },
  avatarDataBySessionContext(avatarData, sessionTopicContext, sessionTopicId){
    if (sessionTopicId && sessionTopicContext && sessionTopicContext[sessionTopicId]) {
      let context = sessionTopicContext[sessionTopicId]["avatarData"] || {}
      return {...avatarData, ...context};
    }
    return avatarData
  },
  formatDate(moment, date) {
    if(date) {
      return moment(new Date(date + "Z")).format('ddd H:m D/YY');
    }
  },
  addOrRemoveScrollbarY(element, _this) {
    let scrollClass = ' add-overflow-y';
    let hasScroll = element.className.includes(scrollClass);

    if(element.scrollHeight > element.offsetHeight) {
      if(!hasScroll) {
        element.className += scrollClass;
      }
    }
    else {
      if(hasScroll) {
        element.className = element.className.replace(scrollClass, '');
      }
    }

    if(_this.shouldScrollBottom) {
      element.scrollTop = element.scrollHeight;
    }
  },
  getSessionMemberById(memberId, list) {
    if(this.props.facilitator.id == memberId) {
      return this.props.facilitator;
    }

    let array = list || this.props.participants;
    for(let i = 0; i < array.length; i++) {
      if(array[i].id == memberId) return array[i];
    }

    return {};
  }
};

export default helpers;
