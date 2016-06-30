import React, {PropTypes} from 'react';

const EmptyCircleButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'emptyCircle' });
    this.props.setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('emptyCircle') + 'btn btn-default fa fa-circle-o' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default EmptyCircleButton;
