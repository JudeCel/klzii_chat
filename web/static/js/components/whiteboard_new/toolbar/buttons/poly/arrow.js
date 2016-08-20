import React from 'react';

const Arrow = React.createClass({
  getInitialState() {
    return { shapeType: 'arrow' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-arrow-right' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default Arrow;
