import React, {PropTypes} from 'react';

const FilledScribbleButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'filledScribble' });
    this.props.setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('filledScribble') + 'btn btn-default fa fa fa-bookmark' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledScribbleButton;
