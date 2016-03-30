import React, { PropTypes, Component } from 'react';

class Delete extends Component {
  render() {
    const { id } = this.props.data;
    const { can, onClick } = this.props;

    if(can) {
      return(
        <i className='icon-cancel-empty' onClick={ onClick } data-id={ id } />
      )
    }
    else {
      return(false)
    }
  }
}

export default Delete;
