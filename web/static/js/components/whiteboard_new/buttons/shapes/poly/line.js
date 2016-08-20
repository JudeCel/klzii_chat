import React from 'react';

const Line = React.createClass({
  getInitialState() {
    return { shapeType: 'line' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-minus' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default Line;
