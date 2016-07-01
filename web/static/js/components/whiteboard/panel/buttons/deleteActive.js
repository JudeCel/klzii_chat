import React, {PropTypes} from 'react';

const DeleteActiveButton = React.createClass({
  onClick() {
    this.props.changeButton({ data: { mode: 'deleteActive' } });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-eraser' aria-hidden='true' onClick={ this.onClick }>*</i>
    )
  }
});

export default DeleteActiveButton;
