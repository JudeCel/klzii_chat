import { combineReducers }  from 'redux';
import chat                 from './chat';
import members              from './members';
import topic                from './topic';
import whiteboard           from './whiteboard';
import currentInput         from './currentInput';
import messages             from './messages';
import resources             from './resources';

export default combineReducers({
  chat: chat,
  members: members,
  topic: topic,
  whiteboard: whiteboard,
  currentInput: currentInput,
  messages: messages,
  resources: resources
});
