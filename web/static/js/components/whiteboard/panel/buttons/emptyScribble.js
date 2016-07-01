import React, {PropTypes} from 'react';

const EmptyScribbleButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent, parent } = this.props;

    parent.hide();
    changeButton({ mode: 'emptyScribble' });
    setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('emptyScribble') + 'btn btn-default fa fa fa-scribd' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default EmptyScribbleButton;
