import React, {PropTypes} from 'react';

const FilledRectButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent, parent } = this.props;

    parent.hide();
    changeButton({ mode: 'filledRect' });
    setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('filledRect') + 'btn btn-default fa fa-square' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledRectButton;
