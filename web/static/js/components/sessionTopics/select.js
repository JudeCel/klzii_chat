import React, {PropTypes}                           from 'react';
import { connect }                                  from 'react-redux';
import { Dropdown, Button, SplitButton, MenuItem }  from 'react-bootstrap'
import Actions                                      from '../../actions/sessionTopic';
import Badge                                        from './badge';

const Select = React.createClass({
  changeSessionTopic(id) {
    const { dispatch, channel, whiteboardChannel } = this.props;
    dispatch(Actions.changeSessionTopic(channel, whiteboardChannel, id));
  },
  render() {
    const { current, sessionTopics, session, unread_messages } = this.props;

    return (
      <div className='col-md-3 topic-select-section'>
        <div className='topic-select-box'>
          <div>
            { session.name }
          </div>

          <Dropdown id='topic-selector' bsSize='medium'>
            <Dropdown.Toggle className='no-border-radius' noCaret>
              <div className='no-border-radius btn btn-default'>
                { current.name }
              </div>
              <div className='no-border-radius btn btn-default'>
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
