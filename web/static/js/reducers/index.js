import { combineReducers }  from 'redux';
import chat              from './chat';
import members              from './members';
import topic              from './topic';
import whiteboard              from './whiteboard';

export default combineReducers({
  chat: chat,
  members: members,
  topic: topic,
  whiteboard: whiteboard
});
