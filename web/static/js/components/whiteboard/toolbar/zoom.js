import React from 'react';
import { OverlayTrigger, Button, Popover } from 'react-bootstrap';
import mobileScreenHelpers from '../../../mixins/mobileHelpers';

const ButtonZoom = React.createClass({
  getInitialState() {
    return { buttonType: 'zoom' };
  },
  onClick() {
    this.props.setType(this.state.buttonType);
  },
  onZoomClick(zoomIn) {
    this.props.zoomIn(zoomIn);
  },
  onZoomRestore() {
    this.props.zoomRestore();
  },
  render() {
   if (mobileScreenHelpers.isMobile()) {
      return (
        <OverlayTrigger ref='zoom' trigger='click' rootClose placement='top' overlay={
            <Popover id='wb-buttons-delete'>
              <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Zoom out') }>
                <i className='btn btn-default fa fa-search-minus' aria-hidden='true' onClick={ this.onZoomClick.bind(this, false) } />
              </OverlayTrigger>

              <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Zoom in') }>
                <i className='btn btn-default fa fa-search-plus' aria-hidden='true' onClick={ this.onZoomClick.bind(this, true) } />
              </OverlayTrigger>

              <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Reset zoom') }>
                <i className='btn btn-default fa fa-arrows-alt' aria-hidden='true' onClick={ this.onZoomRestore.bind(this) } />
              </OverlayTrigger>
            </Popover>
          }>

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
