import React, {PropTypes} from 'react';

const EmptyRectButton = React.createClass({
  onClick() {
    this.props.changeButton({ fill: false, mode: 'emptyRect' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-square-o' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default EmptyRectButton;
