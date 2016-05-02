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
      let syncState_state = syncState(state, action.state)
      return { ...state,
        facilitator: syncState_state.facilitator,
        observers: syncState_state.observers,
        participants: syncState_state.participants
      };
    case Constants.SYNC_MEMBERS_DIFF:
      let syncDiff_state = syncDiff(state, action.diff)
      return { ...state,
        facilitator: syncDiff_state.facilitator,
        observers: syncDiff_state.observers,
        participants: syncDiff_state.participants
      };
    case Constants.SET_CURRENT_USER:
      return { ...state, currentUser: action.user };
    case Constants.UPDATE_MEMBER:
      let update_state = updateMember(state, action.member)
      return { ...state,
        facilitator: update_state.facilitator,
        observers: update_state.observers,
        participants: update_state.participants
      };
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

function onJoin(id, current, newPres) {
  newPres.member.online = true
}

function onLeave(id, current, leftPres) {
  if (current.metas.length == 0) {
    current.member.online = false
  }
}

function updateMmeberStats(state, list) {
  let tmpState = {...state}
  Presence.list(list, (id, {member: member}) => {
    tmpState = updateMember(tmpState, member)
  })
  return tmpState
}

function syncState(state, syncData) {
  let {presences, facilitator, observers, participants} = state
  Presence.syncState(presences, syncData, onJoin, onLeave)
  return updateMmeberStats({facilitator, observers, participants}, presences);
}

function syncDiff(state, diff) {
   let {presences, facilitator, observers, participants} = state
   Presence.syncDiff(presences, diff, onJoin, onLeave)
   return  updateMmeberStats({facilitator, observers, participants}, presences);
}

function updateMember(state, member) {
  switch (member.role) {
    case "facilitator":
      return {...state, facilitator: member }
      break;
    case "participant":
      return {...state, participants: findAndUpdate(state.participants, member) }
      break
    case "observer":
      return {...state, participants: findAndUpdate(state.observers, member) }
      break
    default:
      return state;
  }
}
 function findAndUpdate(members, member) {
   let newMembers = [];
    members.map((m) => {
     if (m.id == member.id) {
       newMembers.push(member);
     }else{
       newMembers.push(m);
     }
   });
   return newMembers;
 }
