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
  }
};

export default helpers;
