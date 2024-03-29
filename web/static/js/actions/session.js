import Constants  from '../constants';
import { Socket } from 'phoenix';
import NotificationsActions from './notifications';
import ReportsActions   from './reports';
import DirectMessageActions from './directMessage';

export function joinChannal(dispatch) {
  const socket = new Socket('/socket', {
    params: {
      token: localStorage.getItem("sessionMemberToken")
    },
    // logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); },
  });

  const channel = socket.channel(`sessions:${localStorage.getItem("sessionId")}`);
  if (channel.state != 'joined') {
    dispatch({
      type: Constants.SET_SESSION_CHANNEL,
      socket,
      channel
    });
    dispatch(Actions.subscribeToSeesionEvents(channel));
    dispatch(DirectMessageActions.subscribeDirectMessageEvents(channel));
    dispatch(NotificationsActions.subscribeNotificationsEvents(channel));
    dispatch(ReportsActions.subscribeReportsEvents(channel));

    channel.join()
    .receive('ok', (session) => {
      dispatch({
        type: Constants.SET_SESSION,
        session
      });
      dispatch(DirectMessageActions.getUnreadCount(channel));
    })
    .receive('error', (error) =>{
      dispatch({
        type: Constants.SOCKET_CONNECTION_ERROR,
        error
      });
    });
  }

  let whenConnectionCrash = (event) =>{
    dispatch({
      type: Constants.SOCKET_CONNECTION_ERROR,
      error: "Connection error, reconnecting"
    });
    dispatch({
      type: Constants.CLOSE_ALL_MODAL_WINDOWS
    });
  }

  socket.onError( (event) => {
    whenConnectionCrash(event);
  });

  socket.connect();

};

function currentMember(dispatch, user) {
  dispatch({
    type: Constants.SET_CURRENT_USER,
    user
  });
}

function updateMember(dispatch, member) {
  dispatch({
    type: Constants.UPDATE_MEMBER,
    member
  })
}

function members(dispatch, members) {
  return dispatch({
    type: Constants.SET_MEMBERS,
    participant: members.participant,
    observer: members.observer,
    facilitator: members.facilitator
  });
}

const Actions = {
  connectToChannel: () => {
    return dispatch => {
      joinChannal(dispatch);
    };
  },
  subscribeToSeesionEvents: (channel) =>{
    return dispatch => {
      dispatch({ type: Constants.SET_SESSION_EVENTS});

      channel.on("self_info", (resp) =>{
        currentMember(dispatch, resp);
      });
      
      channel.on("jwt_token", (resp) =>{
        dispatch({
          type: Constants.SET_JWT_TOKEN,
          token: resp.token,
        });
      });

      channel.on("resources_conf", (resp) =>{
        dispatch({
          type: Constants.SET_RESOURCES_CONF,
          resources_conf: resp.resources_conf,
        });
      });

      channel.on("update_session", (resp) =>{
        dispatch({
          type: Constants.UPDATE_SESSION,
          session: resp,
        });
      });

      channel.on("contact_list_map_struct", (resp) => {
        dispatch({type: 'SET_REPORT_MAP_STRUCT', mapStruct: resp.mapStruct});
      });

      channel.on("error_message", (resp) =>{
        NotificationsActions.showErrorNotification(dispatch, resp);
      });

      channel.on("members", (resp) =>{
        members(dispatch, resp);
      });

      channel.on("unread_messages", (messages) =>{
        return dispatch({
          type: Constants.SET_UNREAD_MESSAGES,
          messages
        });
      });

      channel.on("update_session_topics", (resp) =>{
        return dispatch({
          type: Constants.CHANGE_SESSION_TOPICS,
          all: resp.session_topics
        });
      });

      channel.on("presence_state", (state) =>{
        return dispatch({
          type: Constants.SYNC_MEMBERS_STATE,
          state
        });
      });

      channel.on("presence_diff", (diff) =>{
        return dispatch({
          type: Constants.SYNC_MEMBERS_DIFF,
          diff
        });
      });

      channel.on("update_member", (resp) =>{
        updateMember(dispatch, resp);
      });
    }
  }
}

export default Actions;
