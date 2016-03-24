import React, { PropTypes, Component } from 'react';

class Reply extends Component {
  render() {
    const { id } = this.props.data;
    const { can, onClick } = this.props;

    if(can) {
      return(
        <i className='icon-reply-empty' onClick={ onClick } data-replyid={ id } />
      )
    }
    else {
      return(false)
    }
  }
}

export default Reply;
