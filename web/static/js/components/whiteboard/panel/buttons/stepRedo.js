import React, {PropTypes} from 'react';

const StepRedoButton = React.createClass({
  onClick() {
    this.props.changeButton({ data: { mode: 'stepRedo' } });
  },
  render() {
    return (
      <button className='btn btn-default' onClick={ this.onClick }>
        <i className='fa fa-repeat' aria-hidden='true' />
      </button>
    )
  }
});

export default StepRedoButton;
