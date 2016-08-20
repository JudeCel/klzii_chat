import React from 'react';

const CircleFilled = React.createClass({
  getInitialState() {
    return { shapeType: 'circleFilled' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-circle' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default CircleFilled;
