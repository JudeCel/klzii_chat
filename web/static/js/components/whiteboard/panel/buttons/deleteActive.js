import React, {PropTypes} from 'react';
import {OverlayTrigger, Tooltip }         from 'react-bootstrap'


const DeleteActiveButton = React.createClass({
  onClick() {
    this.props.changeButton({ data: { mode: 'deleteActive' } });
  },
  render() {
    const tooltip =(
      <Tooltip id="tooltip"><strong>Delete</strong></Tooltip>
    );

    return (
      <OverlayTrigger placement="top" overlay={tooltip}>
        <i className='btn btn-default fa fa-eraser' aria-hidden='true' onClick={ this.onClick }></i>
      </OverlayTrigger>
    )
  }
});

export default DeleteActiveButton;
