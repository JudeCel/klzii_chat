import Constants from '../constants';
import { Presence } from 'phoenix';
const initialState = {
  currentUser: { },
  facilitator: {
    avatarData: { base: 0, face: 3, body: 0, hair: 0, desk: 0, head: 0 },
    currentTopic: {}
  },
  participants: [],
  observers: [],
  presences: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SYNC_MEMBERS_STATE:
      return syncState({...state}, action.state);
    case Constants.SYNC_MEMBERS_DIFF:
      return syncDiff({...state}, action.diff)
    case Constants.SET_CURRENT_USER:
      return { ...state, currentUser: action.user };
    case Constants.UPDATE_MEMBER:
      return updateMember({...state}, action.member);
    case Constants.SET_MEMBERS:
      return { ...state,
        facilitator: action.facilitator,
        participants: action.participant,
        observers: getActiveObservers(action.observer),
      };
    case Constants.NEW_MESSAGE_SOUND:
      playSound(action.message, state.currentUser.id);
      return state;
    case Constants.NEW_MESSAGE_ANIMATION:
      return animateMember({...state}, action.message.session_member, state.currentUser.id, true);
    case Constants.NEW_MESSAGE_ANIMATION_STOP:
      return animateMember({...state}, action.member, state.currentUser.id, false);
    default:
      return state;
  }
}

function getActiveObservers(observers) {
  let res = [];
  observers.map((observer) => {
    if (observer.online || observer.sessionContext.hasDirectMessages) {
      res.push(observer);
    }
  });
  return res;
}

function playSound(message, currentUserId) {
  if (message.session_member.id != currentUserId) {
    new Audio('/sounds/newMessage.mp3').play();
  }
}

function animateMember(state, member, currentUserId, animate) {
  if (member.id != currentUserId) {
    let findAndUpdateObj = {
      id: member.id,
      role: member.role,
      animate: animate,
    };
    return updateMember(state, findAndUpdateObj);
  } else {
    return state;
  }
}

function onJoin(state) {
  return (id, current, newPres) => {
    newPres.member.online = true;
    updateMember(state, newPres.member);
  }
}

function onLeave(state) {
  return (id, current, leftPres) => {
    if (current.metas.length == 0) {
      leftPres.member.online = false;
      if (leftPres.member.role == 'observer' && !leftPres.member.sessionContext.hasDirectMessages) {
        removeObserver(state, leftPres.member);
      } else {
        updateMember(state, leftPres.member);
      }
    }
  }
}

function syncState(state, syncData) {
  if (state && state.presences) {
    state.presences = Presence.syncState(state.presences, syncData, onJoin(state), onLeave(state));
  }
  return state;
}

function syncDiff(state, diff) {
  if (state && state.presences) {
    state.presences = Presence.syncDiff(state.presences, diff, onJoin(state), onLeave(state));
  }
  return state;
}


function removeObserver(state, member) {
  let newState = [];
  state.observers.map((observer) => {
    if(observer.id != member.id) {
      newState.push(observer);
    }
  });
  return state.observers = newState;
}
function updateMember(state, member) {
  switch (member.role) {
    case "facilitator":
      Object.assign(state.facilitator, member)
      state.facilitator = {...state.facilitator, ...member};
      break;
    case "participant":
      state.participants = findAndUpdate(state.participants, member);
      break
    case "observer":
      state.observers = findAndUpdate(state.observers, member);
      break
    default:
      return state;
  }
  return state;
}

function findAndUpdate(members, member) {
  let newMembers = [];
  let newMember = true;

  members.map((m) => {
    if(m.id == member.id) {
      newMember = false;
      Object.assign(m, member)
      newMembers.push({...m, ...member});
    }
    else {
      newMembers.push(m);
    }
  });

  if(newMember) {
    newMembers.push(member);
  }

  return newMembers;
}
