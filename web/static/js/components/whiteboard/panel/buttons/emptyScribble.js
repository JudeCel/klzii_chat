import React, {PropTypes} from 'react';

const EmptyScribbleButton = React.createClass({
  onClick() {
    this.props.changeButton({ fill: false, mode: 'emptyScribble' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa fa-scribd' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default EmptyScribbleButton;
