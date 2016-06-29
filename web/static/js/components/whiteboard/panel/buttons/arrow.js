import React, {PropTypes} from 'react';

const ArrowButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'arrow' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-long-arrow-right' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default ArrowButton;
