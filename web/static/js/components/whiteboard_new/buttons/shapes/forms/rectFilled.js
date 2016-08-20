import React from 'react';

const RectFilled = React.createClass({
  getInitialState() {
    return { shapeType: 'rectFilled' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-square' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default RectFilled;
