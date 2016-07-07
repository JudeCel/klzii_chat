import React from 'react';

function _getNotificationOptions(data) {
  return {
    timeOut: data.timeOut || 5000,
    extendedTimeOut: data.extendedTimeOut || 1000
  };
}

const notification = {
  insertDangerously(html) {
    return <span dangerouslySetInnerHTML={{ __html: html }} />
  },
  showNotification(provider, data) {
    switch(data.type) {
      case 'success':
        provider.success(this.insertDangerously(data.message), data.title, _getNotificationOptions(data));
        break;
      case 'warning':
        provider.warning(this.insertDangerously(data.message), data.title, _getNotificationOptions(data));
        break;
      case 'error':
        provider.error(this.insertDangerously(data.message), data.title, _getNotificationOptions(data));
        break;
      default:
    }
  }
}

export default notification;
