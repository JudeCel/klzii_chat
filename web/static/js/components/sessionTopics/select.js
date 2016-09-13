import React, {PropTypes}                           from 'react';
import { connect }                                  from 'react-redux';
import { Dropdown, Button, SplitButton, MenuItem }  from 'react-bootstrap'
import Badge                                        from './badge';
import mixins                                       from '../../mixins';

const Select = React.createClass({
  mixins: [mixins.headerActions],
  changeSessionTopic(id) {
    this.setSessionTopic(id);
  },
  render() {
    const { current, sessionTopics, session, unread_messages } = this.props;

    return (
      <div className='topic-select-section'>
        <div className='topic-select-box'>
          <div className='div-inline-block session-name'>
            <strong>Welcome to:</strong><br />
            { session.name }
          </div>

          <Dropdown id='topic-selector'>
            <Dropdown.Toggle className='no-border-radius' noCaret>
              <div className='no-border-radius btn btn-default name'>
                { current.name }
              </div>
              <div className='no-border-radius btn btn-default dropcaret'>
                <span className='caret'></span>
              </div>
            </Dropdown.Toggle>

            <Dropdown.Menu className='no-border-radius'>
              {
                sessionTopics.map((sessionTopic) => {
                  return (
                    <MenuItem onSelect={ this.changeSessionTopic.bind(this, sessionTopic.id) } key={ 'sessionTopic-' + sessionTopic.id } active={ current.id == sessionTopic.id }>
                      <div className='clearfix'>
                        <span className='pull-left'>{ sessionTopic.name }</span>
                        <span className='pull-right'>
                          <Badge type='reply' data={ unread_messages.session_topics[sessionTopic.id] } />
                          <Badge type='normal' data={ unread_messages.session_topics[sessionTopic.id] } />
                        </span>
                      </div>
                    </MenuItem>
                  )
                })
              }
            </Dropdown.Menu>
          </Dropdown>

          <ul className='unread-messages-section'>
            <li>
              <Badge type='reply' data={ unread_messages.summary } />
            </li>
            <li>
              <Badge type='normal' data={ unread_messages.summary } />
            </li>
          </ul>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    unread_messages: state.messages.unreadMessages,
    session: state.chat.session,
    channel: state.sessionTopic.channel,
    current: state.sessionTopic.current,
    sessionTopics: state.sessionTopic.all,
    whiteboardChannel: state.whiteboard.channel
  };
};

export default connect(mapStateToProps)(Select);
