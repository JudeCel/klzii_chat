import React, {PropTypes} from 'react';

const LineButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'line' });
  },
  render() {
    return (
      <i className='btn btn-default fa' aria-hidden='true' onClick={ this.onClick }>/</i>
    )
  }
});

export default LineButton;
