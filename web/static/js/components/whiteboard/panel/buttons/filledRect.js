import React, {PropTypes} from 'react';

const FilledRectButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'filledRect' });
    this.props.setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('filledRect') + 'btn btn-default fa fa-square' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledRectButton;
