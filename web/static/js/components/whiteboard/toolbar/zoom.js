import React from 'react';
import { OverlayTrigger, Button } from 'react-bootstrap';
import mobileScreenHelpers from '../../../mixins/mobileHelpers';

const ButtonZoom = React.createClass({
  getInitialState() {
    return { buttonType: 'zoom' };
  },
  onClick() {
    this.props.setType(this.state.buttonType);
  },
  render() {
    if (mobileScreenHelpers.isMobile()) {
      return (
        <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Zoom') }>
          <Button className={ this.props.getClassnameParent(this.state.buttonType) + 'btn btn-default' } onClick={ this.onClick }>
            <i className='fa fa-search-plus' aria-hidden='true' />
          </Button>
        </OverlayTrigger>
      )
    } else {
        return false;
    }
  }
});

export default ButtonZoom;
