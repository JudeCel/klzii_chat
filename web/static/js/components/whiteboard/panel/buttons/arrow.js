import React, {PropTypes} from 'react';

const ArrowButton = React.createClass({
  onClick() {
    this.props.changeButton({ mode: 'arrow' });
    this.props.setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('arrow') + 'btn btn-default fa fa-long-arrow-right' } aria-hidden='true' onClick={ this.onClick } active={ true } />
    )
  }
});

export default ArrowButton;
