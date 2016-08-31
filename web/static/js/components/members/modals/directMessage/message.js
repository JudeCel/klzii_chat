import React, {PropTypes} from 'react';
import Avatar             from './../../avatar.js';
import mixins             from '../../../../mixins';

const Message = React.createClass({
  mixins: [mixins.helpers],
  render() {
    const { sender, message, type } = this.props;

    return (
      <div className='message'>
        <div className='avatar'>
          <Avatar member={ sender } specificId={ 'direct-message-right' + message.id } />
        </div>

        <div className='info'>
          <div className='header'>
            <div className='col-md-6'>
              <strong>{ sender.username }</strong>
            </div>

            <div className='col-md-6 text-right'>
              <span>{ this.formatDate(message.createdAt) }</span>
            </div>
          </div>

          <div className={ `col-md-12 body message-state-${ type }` }>
            { message.text }
          </div>
        </div>
      </div>
    )
  }
});

export default Message;
