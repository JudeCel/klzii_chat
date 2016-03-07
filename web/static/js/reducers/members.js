import Constants from '../constants';

const initialState = {
  currentUser: { },
  facilitator: {
    avatar_info: "0:0:0:0:0"
  },
  participants: [],
  observers: []
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_CURRENT_USER:
      return { ...state, currentUser: action.user };
    case Constants.UPDATE_MEMBER:
      return  updateMember(state, action);

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

function updateMember(state, action) {
  switch (action.member.role) {
    case "facilitator":
      return {...state, facilitator: action.member }
      break;
    case "participant":
      return {...state, participants: findAndUpdate(state.participants, action.member) }
      break
    case "observer":
      return {...state, participants: findAndUpdate(state.observers, action.member) }
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
