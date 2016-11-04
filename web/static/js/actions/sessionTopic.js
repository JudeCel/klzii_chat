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
    dispatch(WhiteboardActions.connectToChannel(socket, sessionTopicId));
    dispatch(Actions.subscribeEvents(channel));
    dispatch(PinboardActions.subscribePinboardEvents(channel));

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

function leave_channal(dispatch, channal) {
  channal.leave();
  dispatch({ type: Constants.SET_SESSION_TOPIC });
}

function tidyUp(dispatch){
  dispatch({ type: Constants.TIDY_UP_CONSOLE });
  dispatch({ type: Constants.TIDY_UP_WHITEBOARD });
  dispatch({ type: Constants.TIDY_UP_PINBOARD });
  dispatch({ type: Constants.TIDY_UP_MESSAGES });
  dispatch({ type: Constants.TIDY_UP_SURVE });
  dispatch({ type: Constants.CLOSE_ALL_MODAL_WINDOWS });
}

const Actions = {
  subscribeEvents: (channel) => {
      return dispatch => {
        channel.on("read_message", (messages) =>{
          return dispatch({
            type: Constants.SET_UNREAD_MESSAGES,
            messages
          });
        });
        channel.on("board_message", (resp) =>{
          return dispatch({
            type: Constants.UPDATE_SESSION_TOPIC,
            session_topic: resp
          });
        });
      }
  },
  selectCurrent: (socket, sessionTopics, currentTopic) =>{
    return dispatch => {
      dispatch({
        type: Constants.SET_SESSION_TOPICS,
        all: sessionTopics
      });

      let sessionTopicId = selectTopic(sessionTopics, currentTopic);

      if (sessionTopicId) {
        joinChannal(dispatch, socket, sessionTopicId.id);
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
      leave_channal(dispatch, currentChannal);
      tidyUp(dispatch);
      joinChannal(dispatch, currentChannal.socket, sessionTopicId);
    }
  }
}

function selectTopic(topics, currentTopic) {
  return(selectCurrenTopic(topics,currentTopic) || selectLandingTopic(topics))
}

function selectCurrenTopic(topics, currentTopic) {
  for(var i in topics) {
    if(topics[i].id == currentTopic.id) {
      return topics[i];
    }
  }
}

function selectLandingTopic(topics) {
  for(var i in topics) {
    if(topics[i].landing) {
      return topics[i];
    }
  }
  return topics[0];
}

export default Actions;
