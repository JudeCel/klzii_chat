import Constants from '../constants';

const initialState = {
  all: [],
  ready: false,
  unreadMessages: {session_topics: {}, summary: {normal: 0, reply: 0 }}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SET_MESSAGES:
      return { ...state, all: action.messages };

    case Constants.SET_UNREAD_MESSAGES:
      return { ...state, unreadMessages: action.messages };

    case Constants.NEW_MESSAGE:
      return { ...state, all: newMessage(state.all, action.message) };

    case Constants.DELETE_MESSAGE:
      return { ...state, all: deleteMessage(state.all, action.message)};

    case Constants.UPDATE_MESSAGE:
      return { ...state, all: updateMessage(state.all, action.message)};

    case Constants.SET_MESSAGES_EVENTS:
      return { ...state, ready: true };

    case Constants.TIDY_UP_MESSAGES:
      return { ...state, all: [] };

    default:
      return state;
  }
}

function deleteMessage(messages, message) {
  let newArray = [];
  messages.map((m) => {
    if (message.replyId) {
      let newM = { ...m, m };
      let newReplies = [];
      m.replies.map((r) => {
        if (r.id != message.id) {
          if (r.id == message.replyId) {
            let newR = { ...r, r };
            let newReplyReplies = [];
            r.replies.map((rr) => {
              if (rr.id != message.id) {
                newReplyReplies.push(rr);
              }
            });
            newR.replies = newReplyReplies;
            newReplies.push(newR);
          } else {
            newReplies.push(r);
          }
        }
      });
      newM.replies = newReplies;
      newArray.push(newM);
    } else {
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
    if (message.replyId) {
      let newM = { ...m, m };
      let newReplies = [];
      m.replies.map((r) => {
        if (r.id == message.id) {
          newReplies.push(message);
        } else {
          if (r.id == message.replyId) {
            let newR = { ...r, r };
            let newReplyReplies = [];
            r.replies.map((rr) => {
              if (rr.id == message.id) {
                newReplyReplies.push(message);
              } else {
                newReplyReplies.push(rr);
              }
            });
            newR.replies = newReplyReplies;
            newReplies.push(newR);
          } else {
            newReplies.push(r);
          }
        }
      });
      newM.replies = newReplies;
      newArray.push(newM);
    } else {
      if (m.id == message.id) {
        newArray.push({...message, m});
      } else {
        newArray.push(m);
      }
    }
  });
  return newArray
}

function newMessage(messages, message) {
  let newArray = [];
  if (message.replyId) {
    messages.map((m) => {
      if (m.id == message.replyId) {
        let newM = Object.assign({}, m);
        newM.replies.push(message);
        newArray.push(newM);
      } else {
        let newM = { ...m, m };
        let newReplies = [];
        m.replies.map((r) => {
          if (r.id == message.replyId) {
            let newR = Object.assign({}, r);
            newR.replies.push(message);
            newReplies.push(newR);
          } else {
            newReplies.push(m);
          }
        });
        newM.replies = newReplies;
        newArray.push(newM);
      }
    });
  } else {
    newArray = [...messages, message];
  }
  return newArray;
}
