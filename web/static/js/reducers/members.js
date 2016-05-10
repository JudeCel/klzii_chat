import Constants from '../constants';
import { Presence } from 'phoenix';
const initialState = {
  currentUser: { },
  facilitator: {
    avatarData: { base: 0, face: 3, body: 0, hair: 0, desk: 0, head: 0 }
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
      return updateMember({...state}, action.member);;
    case Constants.SET_MEMBERS:
      return { ...state,
        facilitator: action.facilitator,
        observers: action.observer,
        participants: action.participant
      };
    default:
      return state;
  }
}

function onJoin(state) {
  return (id, current, newPres) => {
    newPres.member.online = true
    updateMember(state, newPres.member)
  }
}

function onLeave(state) {
  return (id, current, leftPres) =>{
    if (current.metas.length == 0) {
      leftPres.member.online = false
      updateMember(state, leftPres.member)
    }
  }
}

function syncState(state, syncData) {
  Presence.syncState(state.presences, syncData, onJoin(state), onLeave(state))
  return  state
}

function syncDiff(state, diff) {
   Presence.syncDiff(state.presences, diff, onJoin(state), onLeave(state))
   return  state;
}

function updateMember(state, member) {
  switch (member.role) {
    case "facilitator":
      Object.assign(state.facilitator, member)
      state.facilitator = {...state.facilitator, member};
      break;
    case "participant":
      state.participants =  findAndUpdate(state.participants, member);
      break
    case "observer":
      state.observers = findAndUpdate(state.observers, member) ;
      break
    default:
      return state;
  }
  return state;
}
 function findAndUpdate(members, member) {
   let newMembers = [];
    members.map((m) => {
     if (m.id == member.id) {
       newMembers.push(Object.assign(m, member));
     }else{
       newMembers.push(m);
     }
   });
   return newMembers;
 }
