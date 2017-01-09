import React from 'react';
import { OverlayTrigger, Button } from 'react-bootstrap';

const ButtonsHand = React.createClass({
  getInitialState() {
    return { buttonType: 'none' };
  },
  onClick() {
    this.props.setType(this.state.buttonType);
  },
  render() {
    return (
      <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Selection') }>
        <Button className={ this.props.getClassnameParent(this.state.buttonType) + 'btn btn-default' } onClick={ this.onClick }>
          <i className='fa fa-hand-paper-o' aria-hidden='true' />
        </Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsHand;
