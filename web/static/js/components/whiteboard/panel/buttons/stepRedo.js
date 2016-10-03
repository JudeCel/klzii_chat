import React, {PropTypes} from 'react';
import { OverlayTrigger, Tooltip }         from 'react-bootstrap'


const StepRedoButton = React.createClass({
  onClick() {
    this.props.changeButton({ data: { mode: 'stepRedo' } });
  },
  render() {
    const tooltip =(
      <Tooltip id="tooltip"><strong>Redo</strong></Tooltip>
    );

    return (
      <OverlayTrigger placement="top" overlay={tooltip}>
        <button className='btn btn-default' onClick={ this.onClick }>
          <i className='fa fa-repeat' aria-hidden='true' />
        </button>
      </OverlayTrigger>
    )
  }
});

export default StepRedoButton;
