const helpers = {
  getConsoleResourceId(type) {
    switch (type) {
      case "link":
        return this.props.console['video_id'];
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
  avatarDataBySessionContext(avatarData, sessionTopicContext, sessionTopicId){
    if (sessionTopicId && sessionTopicContext && sessionTopicContext[sessionTopicId]) {
      let context = sessionTopicContext[sessionTopicId]["avatarData"] || {}
      return {...avatarData, ...context};
    }
    return avatarData
  },
  formatDate(moment, date) {
    return moment(new Date(date)).format('ddd h:mm D/YY');
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
  }
};

export default helpers;
