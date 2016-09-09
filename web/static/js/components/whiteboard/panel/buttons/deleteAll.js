import React, {PropTypes} from 'react';
import {OverlayTrigger, Tooltip }         from 'react-bootstrap'

const DeleteAllButton = React.createClass({
  onClick() {
    const { changeButton, parent } = this.props;

    parent.hide();
    changeButton({ data: { mode: 'deleteAll' } });
  },
  render() {
    const tooltip =(
      <Tooltip id="tooltip"><strong>Delete All</strong></Tooltip>
    );

    return (
      <OverlayTrigger placement="top" overlay={tooltip}>
        <i className='btn btn-default fa fa-eraser' aria-hidden='true' onClick={ this.onClick } >*</i>
      </OverlayTrigger>
    )
  }
});

export default DeleteAllButton;
