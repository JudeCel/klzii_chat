import React from 'react';

const ScribbleEmpty = React.createClass({
  getInitialState() {
    return { shapeType: 'scribbleEmpty' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-scribd' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default ScribbleEmpty;
