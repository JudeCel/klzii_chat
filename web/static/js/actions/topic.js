import Constants        from '../constants';
import MessagesActions  from './messages';

export function joinChannal(dispatch, socket, topicId) {
  const channel = socket.channel("topics:" + topicId);
  dispatch({
    type: Constants.SET_TOPIC_CHANNEL,
    channel
    });

  if (channel.state != 'joined') {
    channel.join()
    .receive('ok', (resp) => {
      dispatch(MessagesActions.subscribeMessageEvents(channel))
      dispatch({
          type: Constants.SET_MESSAGES,
          messages: resp
        });
    })
    .receive('error', (resp) =>{
      return dispatch({
          type: Constants.SOCKET_CONNECTED,
          error: resp
        });
    });
  }
};

const Actions = {
  connectToTopicChannel: (socket, topicId) => {
    return dispatch => {
      return joinChannal(dispatch, socket, topicId);
    };
  }
}


export default Actions;
