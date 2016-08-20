import React from 'react';

const CircleEmpty = React.createClass({
  getInitialState() {
    return { shapeType: 'circleEmpty' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-circle-o' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default CircleEmpty;
