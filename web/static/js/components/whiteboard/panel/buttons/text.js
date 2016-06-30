import React, {PropTypes} from 'react';

const ArrowButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'text', textValue: 'aaa' });
    this.props.setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('text') + 'btn btn-default fa' } aria-hidden='true' onClick={ this.onClick }>ABC</i>
    )
  }
});

export default ArrowButton;
