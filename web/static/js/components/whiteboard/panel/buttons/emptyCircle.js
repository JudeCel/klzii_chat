import React, {PropTypes} from 'react';

const EmptyCircleButton = React.createClass({
  onClick() {
    this.props.changeButton({ fill: false, mode: 'emptyCircle' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-circle-o' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default EmptyCircleButton;
