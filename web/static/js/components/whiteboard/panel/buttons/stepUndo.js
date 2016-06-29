import React, {PropTypes} from 'react';

const StepUndoButton = React.createClass({
  onClick() {
  },
  render() {
    return (
      <button className='btn btn-default'>
        <i className='fa fa-undo' aria-hidden='true' onClick={ this.onClick } />
      </button>
    )
  }
});

export default StepUndoButton;
