import React, {PropTypes} from 'react';

const FilledRectButton = React.createClass({
  onClick() {
    this.props.changeButton({ fill: true, mode: 'filledRect' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-square' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledRectButton;
