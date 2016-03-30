import React, { PropTypes, Component } from 'react';

class Edit extends Component {
  render() {
    const { id, body } = this.props.data;
    const { can, onClick } = this.props;

    if(can) {
      return(
        <i className='icon-pencil' onClick={ onClick } data-id={ id } data-body={ body } />
      )
    }
    else {
      return(false)
    }
  }
}

export default Edit;
