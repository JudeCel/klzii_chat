import React from 'react';
import { OverlayTrigger, Button } from 'react-bootstrap';

const ButtonZoom = React.createClass({
  getInitialState() {
    return { buttonType: 'zoom' };
  },
  onClick() {
    this.props.setType(this.state.buttonType);
  },
  render() {
    return (
      <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Zoom') }>
        <Button className={ this.props.getClassnameParent(this.state.buttonType) + 'btn btn-default' } onClick={ this.onClick }>
          <i className='fa fa-search-plus' aria-hidden='true' />
        </Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonZoom;
