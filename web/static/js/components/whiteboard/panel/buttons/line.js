import React, {PropTypes} from 'react';

const LineButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent, parent } = this.props;

    parent.hide();
    changeButton({ mode: 'line' });
    setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('line') + 'btn btn-default fa' } aria-hidden='true' onClick={ this.onClick }>/</i>
    )
  }
});

export default LineButton;
