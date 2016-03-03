import Constants        from '../constants';
import MessagesActions  from './messages';

export function joinChannal(dispatch, socket, topicId) {
  const channel = socket.channel("topics:" + topicId);
  dispatch({
    type: Constants.SET_TOPIC_CHANNEL,
    channel,
    currentId: topicId
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

function selectActive(topics) {
  let currentTopicId = null;
  topics.map((t) =>{
    if (t.active) {
      currentTopicId = t.id;
    }
  })
  return (currentTopicId || topics[0].id)
}

function leave_chanal(dispatch, channal) {
  channal.leave();
  dispatch({ type: Constants.LEAVE_TOPIC });
}

const Actions = {
  selectCurrent: (socket, topics) =>{
    return dispatch => {
      dispatch({
        type: Constants.SET_TOPICS,
        all: topics
      });
      let topic = selectActive(topics);
      joinChannal(dispatch, socket, topic);
    }
  },
  changeTopic: (currentChannal, topicId) =>{
    return dispatch => {
      leave_chanal(dispatch, currentChannal);
      joinChannal(dispatch, currentChannal.socket, topicId);
    }
  }
}


export default Actions;
