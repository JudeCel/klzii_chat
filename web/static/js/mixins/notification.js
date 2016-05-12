function _getNotificationOptions(data) {
  return {
    timeOut: data.timeOut || 5000,
    extendedTimeOut: data.extendedTimeOut || 1000
  };
}

const notification = {
  showNotification(provider, data) {
    switch(data.type) {
      case 'success':
        provider.success(data.message, data.title, _getNotificationOptions(data));
        break;
      case 'warning':
        provider.warning(data.message, data.title, _getNotificationOptions(data));
        break;
      case 'error':
        provider.error(data.message, data.title, _getNotificationOptions(data));
        break;
      default:
    }
  }
}

export default notification;
