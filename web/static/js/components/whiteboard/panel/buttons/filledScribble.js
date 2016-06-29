import React, {PropTypes} from 'react';

const FilledScribbleButton = React.createClass({
  onClick() {
    this.props.changeButton({ fill: true, mode: 'filledScribble' });
  },
  render() {
    return (
      <i className='btn btn-default fa fa fa-bookmark' aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledScribbleButton;
