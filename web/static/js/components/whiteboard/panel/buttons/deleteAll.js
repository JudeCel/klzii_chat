import React, {PropTypes} from 'react';

const DeleteAllButton = React.createClass({
  onClick() {
    this.props.changeButton({ data: { mode: 'deleteAll' } });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-eraser' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default DeleteAllButton;
