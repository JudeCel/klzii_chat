import React, {PropTypes} from 'react';
import { OverlayTrigger, Tooltip }         from 'react-bootstrap'


const StepUndoButton = React.createClass({
  onClick() {
    this.props.changeButton({ data: { mode: 'stepUndo' } });
  },
  render() {
    const tooltip =(
      <Tooltip id="tooltip"><strong>Undo</strong></Tooltip>
    );

    return (
      <OverlayTrigger placement="top" overlay={tooltip}>
        <button className='btn btn-default' onClick={ this.onClick }>
          <i className='fa fa-undo' aria-hidden='true' />
        </button>
      </OverlayTrigger>

    )
  }
});

export default StepUndoButton;
