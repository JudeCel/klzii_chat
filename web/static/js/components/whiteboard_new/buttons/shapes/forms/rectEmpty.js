import React from 'react';

const RectEmpty = React.createClass({
  getInitialState() {
    return { shapeType: 'rectEmpty' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-square-o' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default RectEmpty;
