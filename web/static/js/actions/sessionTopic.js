import Constants        from '../constants';
import MessagesActions  from './messages';
import ConsoleActions   from './console';
import WhiteboardActions   from './whiteboard';

export function joinChannal(dispatch, socket, sessionTopicId) {
  const channel = socket.channel("session_topic:" + sessionTopicId);

  if (channel.state != 'joined') {
    dispatch({
      type: Constants.SET_SESSION_TOPIC_CHANNEL,
      channel,
      currentId: sessionTopicId
    });
    dispatch(MessagesActions.subscribeMessageEvents(channel));
    dispatch(ConsoleActions.subscribeConsoleEvents(channel));
    dispatch(WhiteboardActions.connectToChannel(socket, sessionTopicId));
    dispatch(Actions.subscribeEvents(channel));


    channel.join()
    .receive('ok', (resp) => {
      dispatch({
        type: Constants.SET_MESSAGES,
        messages: resp
      });
    })
    .receive('error', (resp) =>{
      return dispatch({
        type: Constants.SOCKET_CONNECTION_ERROR,
        error: "Channel ERROR!!!"
      });
    });
  }
};

function selectActive(sessionTopics) {
  let currentSessionTopicId = null;
  topics.map((t) =>{
    if (t.active) {
      currentSessionTopicId = t.id;
    }
  })
  return (currentSessionTopicId || sessionTopics[0].id)
}

function leave_chanal(dispatch, channal) {
  channal.leave();
  dispatch({ type: Constants.SET_SESSION_TOPIC });
}

const Actions = {
  subscribeEvents: (channel) => {
      return dispatch => {
        channel.on("board_message", (resp) =>{
          return dispatch({
            type: Constants.UPDATE_SESSION_TOPIC,
            session_topic: resp
          });
        });
      }
  },
  selectCurrent: (socket, sessionTopics) =>{
    return dispatch => {
      dispatch({
        type: Constants.SET_SESSION_TOPICS,
        all: sessionTopics
      });
      let sessionTopicId = sessionTopics[0].id;
      joinChannal(dispatch, socket, sessionTopicId);
    }
  },
  changeSessionTopic: (currentChannal, sessionTopicId) =>{
    return dispatch => {
      leave_chanal(dispatch, currentChannal);
      joinChannal(dispatch, currentChannal.socket, sessionTopicId);
    }
  }
}


export default Actions;
