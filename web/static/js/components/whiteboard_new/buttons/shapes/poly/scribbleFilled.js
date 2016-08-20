import React from 'react';

const ScribbleFilled = React.createClass({
  getInitialState() {
    return { shapeType: 'scribbleFilled' };
  },
  onClick() {
    this.props.setActiveButton(this.state.shapeType);
  },
  render() {
    return (
      <i className={ this.props.getClassnameChild(this.state.shapeType) + 'btn btn-default fa fa-bookmark' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default ScribbleFilled;
