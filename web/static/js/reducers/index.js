import { combineReducers } from 'redux';
import chat                from './chat';
import members             from './members';
import sessionTopic        from './sessionTopic';
import whiteboard          from './whiteboard';
import currentInput        from './currentInput';
import messages            from './messages';
import resources           from './resources';
import notifications       from './notifications';
import modalWindows        from './modalWindows';
import miniSurveys         from './miniSurveys';
import directMessages      from './directMessages';
import reports             from './reports';
import utility             from './utility';
import pinboard            from './pinboard';
import sessionTopicConsole from './sessionTopicConsole';

export default combineReducers({
  chat: chat,
  members: members,
  sessionTopic: sessionTopic,
  whiteboard: whiteboard,
  currentInput: currentInput,
  messages: messages,
  resources: resources,
  notifications: notifications,
  modalWindows: modalWindows,
  miniSurveys: miniSurveys,
  reports: reports,
  directMessages: directMessages,
  utility: utility,
  pinboard: pinboard,
  sessionTopicConsole: sessionTopicConsole
});
