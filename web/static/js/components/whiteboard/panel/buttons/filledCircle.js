import React, {PropTypes} from 'react';

const FilledCircleButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'filledCircle' });
    this.props.setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('filledCircle') + 'btn btn-default fa fa-circle' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledCircleButton;
