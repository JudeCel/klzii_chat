import Constants from '../constants';

const initialState = {
  all: [],
  ready: false
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_MESSAGES:
      return { ...state, all: action.messages };

    case Constants.NEW_MESSAGE:
      return { ...state, all: newMessage(state.all, action.message) };

    case Constants.DELETE_MESSAGE:
      return { ...state, all: deleteMessage(state.all, action.message)};

    case Constants.UPDATE_MESSAGE:
      return { ...state, all: updateMessage(state.all, action.message)};

    case Constants.SET_MESSAGES_EVENTS:
      return { ...state, ready: true };
    default:
      return state;
  }
}

function deleteMessage(messages, message) {
  let newArray = [];
  messages.map((m) => {
    if ((m.id == message.replyId)) {
      let newM = { ...m, m };
      let newReplies = [];
      m.replies.map((r) =>{
        if (!(r.id == message.id)) {
          newReplies.push(r);
        }
      });
      newM.replies = newReplies;
      newArray.push(newM);
    }else {
      if (!(m.id == message.id)) {
        newArray.push(m);
      }
    }
  });
  return newArray;
}

function updateMessage(messages, message) {
  let newArray = [];
  messages.map((m) => {
    if (m.id == message.replyId) {
      let newM = { ...m, m };
      let newReplies = [];
      m.replies.map((r) =>{
        if (r.id == message.id) {
          newReplies.push(message);
        }else {
          newReplies.push(r);
        }
      });
      newM.replies = newReplies;
      newArray.push(newM);
    }else {
      if (m.id == message.id) {
        newArray.push({...message, m});
      }else {
        newArray.push(m);
      }
    }
  });
  return newArray
}
function newMessage(messages, message) {
  let newArray = [];
  if (message.replyId) {
    messages.map((m) =>{
      if (m.id == message.replyId) {
        let newM =  Object.assign({}, m);
        newM.replies.push(message);
        newArray.push(newM);
      }else {
        newArray.push(m);
      }
    });
  }else {
    newArray = [...messages, message];
  }
  return newArray;
}