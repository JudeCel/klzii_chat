import React from 'react';

const History = React.createClass({
  onClick(type) {
    this.props.setHistory(type);
  },
  render() {
    return (
      <span>
        <button className='btn btn-default' onClick={ this.onClick.bind(this, 'undo') }>
          <i className='fa fa-undo' aria-hidden='true' />
        </button>
        <button className='btn btn-default' onClick={ this.onClick.bind(this, 'redo') }>
          <i className='fa fa-repeat' aria-hidden='true' />
        </button>
      </span>
    )
  }
});

export default History;
