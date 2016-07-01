import React, {PropTypes} from 'react';

const EmptyRectButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent, parent } = this.props;

    parent.hide();
    changeButton({ mode: 'emptyRect' });
    setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('emptyRect') + 'btn btn-default fa fa-square-o' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default EmptyRectButton;
