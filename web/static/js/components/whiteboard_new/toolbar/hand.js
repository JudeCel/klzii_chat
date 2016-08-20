import React from 'react';

const Hand = React.createClass({
  getInitialState() {
    return { buttonType: 'none' };
  },
  onClick() {
    this.props.setType(this.state.buttonType);
  },
  render() {
    return (
      <button className={ this.props.getClassnameParent(this.state.buttonType) + 'btn btn-default' } onClick={ this.onClick }>
        <i className='fa fa-hand-paper-o' aria-hidden='true' />
      </button>
    )
  }
});

export default Hand;
