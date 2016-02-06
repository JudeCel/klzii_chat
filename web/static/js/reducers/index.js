import { combineReducers }  from 'redux';
import chat              from './chat';
import members              from './members';
import topic              from './topic';

export default combineReducers({
  chat: chat,
  members: members,
  topic: topic
});
