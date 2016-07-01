import React, {PropTypes} from 'react';

const StepUndoButton = React.createClass({
  onClick() {
    this.props.changeButton({ data: { mode: 'stepUndo' } });
  },
  render() {
    return (
      <button className='btn btn-default' onClick={ this.onClick }>
        <i className='fa fa-undo' aria-hidden='true' />
      </button>
    )
  }
});

export default StepUndoButton;
