import React, {PropTypes} from 'react';

const FilledCircleButton = React.createClass({
  onClick() {
    this.props.changeButton({ fill: true, mode: 'filledCircle' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa-circle' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledCircleButton;
