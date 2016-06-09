import React, {PropTypes} from 'react';
import moment             from 'moment';
import Avatar             from './../../avatar.js';
import mixins             from '../../../../mixins';

const Message = React.createClass({
  mixins: [mixins.helpers],
  render() {
    const { member, message, type } = this.props;

    return (
      <div className='message'>
        <div className='avatar'>
          <Avatar member={ member } specificId={ 'direct-message-right' + message.id } />
        </div>

        <div className='info'>
          <div className='header'>
            <div className='col-md-6'>
              <strong>{ member.username }</strong>
            </div>

            <div className='col-md-6 text-right'>
              <span className='badge'>42</span>
              <span>{ this.formatDate(moment, message.createdAt) }</span>
            </div>
          </div>

          <div className={ `col-md-12 message-state-${ type }` }>
            { message.text }
          </div>
        </div>
      </div>
    )
  }
});

export default Message;
