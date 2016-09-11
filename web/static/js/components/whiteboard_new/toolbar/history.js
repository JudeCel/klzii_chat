import React from 'react';
import { OverlayTrigger, Button } from 'react-bootstrap';

const History = React.createClass({
  onClick(type) {
    this.props.setHistory(type);
  },
  render() {
    return (
      <span>
        <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Undo') }>
          <Button className='btn btn-default' onClick={ this.onClick.bind(this, 'undo') }>
            <i className='fa fa-undo' aria-hidden='true' />
          </Button>
        </OverlayTrigger>
        <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Redo') }>
          <Button className='btn btn-default' onClick={ this.onClick.bind(this, 'redo') }>
            <i className='fa fa-repeat' aria-hidden='true' />
          </Button>
        </OverlayTrigger>
      </span>
    )
  }
});

export default History;
