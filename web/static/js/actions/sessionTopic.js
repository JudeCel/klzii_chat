import Constants         from '../constants';
import MessagesActions   from './messages';
import ConsoleActions    from './console';
import WhiteboardActions from './whiteboard';
import PinboardActions   from './pinboard';

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
    dispatch(PinboardActions.subscribePinboardEvents(channel));
    dispatch(WhiteboardActions.connectToChannel(socket, sessionTopicId));
    dispatch(Actions.subscribeEvents(channel));

    channel.join()
    .receive('ok', (resp) => {
      dispatch(PinboardActions.get(channel));
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

      if (sessionTopicId) {
        joinChannal(dispatch, socket, sessionTopicId);
      }else{
        dispatch({
          type: Constants.SOCKET_CONNECTION_ERROR,
          error: "This session is without Topics"
        });
      }
    }
  },
  changeSessionTopic: (currentChannal, whiteboardChannel, sessionTopicId) =>{
    return dispatch => {
      whiteboardChannel.leave();
      leave_chanal(dispatch, currentChannal);
      joinChannal(dispatch, currentChannal.socket, sessionTopicId);
    }
  }
}


export default Actions;
