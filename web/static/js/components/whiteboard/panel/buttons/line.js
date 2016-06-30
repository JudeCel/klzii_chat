import React, {PropTypes} from 'react';

const LineButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'line' });
    this.props.setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('line') + 'btn btn-default fa' } aria-hidden='true' onClick={ this.onClick }>/</i>
    )
  }
});

export default LineButton;
