const Constants = {
  SET_SESSION:             'SET_SESSION',
  SET_CURRENT_USER:        'SET_CURRENT_USER',
  SOCKET_CONNECTED:        'SOCKET_CONNECTED',
  SET_SESSION_EVENTS:      'SET_SESSION_EVENTS',
  SET_SESSION_CHANNEL:     'SET_SESSION_CHANNEL',
  SOCKET_CONNECTION_ERROR: 'SOCKET_CONNECTION_ERROR',

  SET_WHITEBOARD_SHAPE:          'SET_WHITEBOARD_SHAPE',
  SET_WHITEBOARD_EVENTS:         'SET_WHITEBOARD_EVENTS',
  SET_WHITEBOARD_CHANNEL:        'SET_WHITEBOARD_CHANNEL',
  SET_WHITEBOARD_HISTORY:        'SET_WHITEBOARD_HISTORY',
  DELETE_WHITEBOARD_SHAPE:       'DELETE_WHITEBOARD_SHAPE',
  UPDATE_WHITEBOARD_SHAPE:       'UPDATE_WHITEBOARD_SHAPE',
  DELETE_ALL_WHITEBOARD_SHAPES:  'DELETE_ALL_WHITEBOARD_SHAPES',

  SET_SESSION_TOPICS:        'SET_SESSION_TOPICS',
  UPDATE_SESSION_TOPIC:      'UPDATE_SESSION_TOPIC',
  SET_SESSION_TOPIC:         'SET_SESSION_TOPIC',
  SET_SESSION_TOPIC_CHANNEL: 'SET_SESSION_TOPIC_CHANNEL',

  SCREEN_SIZE_CHANGED: 'SCREEN_SIZE_CHANGED',

  GET_RESOURCE:          'GET_RESOURCE',
  CLEAN_RESOURCE:        'CLEAN_RESOURCE',
  DELETE_RESOURCES:      'DELETE_RESOURCES',
  SET_FILE_RESOURCES:    'SET_FILE_RESOURCES',
  SET_VIDEO_RESOURCES:   'SET_VIDEO_RESOURCES',
  SET_IMAGE_RESOURCES:   'SET_IMAGE_RESOURCES',
  SET_AUDIO_RESOURCES:   'SET_AUDIO_RESOURCES',
  SET_GALLERY_RESOURCES: 'SET_GALLERY_RESOURCES',

  SET_SURVEYS: 'SET_SURVEYS',
  CREATE_SURVEY: 'CREATE_SURVEY',
  DELETE_SURVEY: 'DELETE_SURVEY',
  SET_CONSOLE_SURVEY:   'SET_CONSOLE_SURVEY',
  SET_VIEW_SURVEY:      'SET_VIEW_SURVEY',

  SET_CONSOLE: 'SET_CONSOLE',
  SET_CONSOLE_RESOURCE: 'SET_CONSOLE_RESOURCE',

  SET_DIRECT_MESSAGES: 'SET_DIRECT_MESSAGES',
  CREATE_DIRECT_MESSAGE: 'CREATE_DIRECT_MESSAGE',
  READ_DIRECT_MESSAGES: 'READ_DIRECT_MESSAGES',
  NEW_DIRECT_MESSAGE: 'NEW_DIRECT_MESSAGE',
  UNREAD_DIRECT_MESSAGES: 'UNREAD_DIRECT_MESSAGES',
  CLEAR_DIRECT_MESSAGES: 'CLEAR_DIRECT_MESSAGES',
  LAST_DIRECT_MESSAGES: 'LAST_DIRECT_MESSAGES',
  ADD_DIRECT_MESSAGES: 'ADD_DIRECT_MESSAGES',
  FETCHING_DIRECT_MESSAGES: 'FETCHING_DIRECT_MESSAGES',

  SET_REPORTS: 'SET_REPORTS',
  CREATE_REPORT: 'CREATE_REPORT',
  RECREATE_REPORT: 'RECREATE_REPORT',
  UPDATE_REPORT: 'UPDATE_REPORT',
  DELETE_REPORT: 'DELETE_REPORT',

  SET_MEMBERS:   'SET_MEMBERS',
  UPDATE_MEMBER: 'UPDATE_MEMBER',
  SYNC_MEMBERS_STATE: 'SYNC_MEMBERS',
  SYNC_MEMBERS_DIFF: 'SYNC_MEMBERS_DIFF',

  NEW_MESSAGE:          'NEW_MESSAGE',
  SET_MESSAGES:         'SET_MESSAGES',
  DELETE_MESSAGE:       'DELETE_MESSAGE',
  UPDATE_MESSAGE:       'UPDATE_MESSAGE',
  SET_MESSAGES_EVENTS:  'SET_MESSAGES_EVENTS',
  SET_UNREAD_MESSAGES:  'SET_UNREAD_MESSAGES',

  SHOW_NOTIFICATION: 'SHOW_NOTIFICATION',
  CLEAR_NOTIFICATION: 'CLEAR_NOTIFICATION',

  SAVE_FACILITATOR_BOARD: 'SAVE_FACILITATOR_BOARD',

  OPEN_MODAL_WINDOW: 'OPEN_MODAL_WINDOW',
  CLOSE_ALL_MODAL_WINDOWS: 'CLOSE_ALL_MODAL_WINDOWS',

  SET_INPUT_EDIT:          'SET_INPUT_EDIT',
  SET_INPUT_REPLY:         'SET_INPUT_REPLY',
  SET_INPUT_EMOTION:       'SET_INPUT_EMOTION',
  CHANGE_INPUT_VALUE:      'CHANGE_INPUT_VALUE',
  SET_INPUT_DEFAULT_STATE: 'SET_INPUT_DEFAULT_STATE'
};

export default Constants;
