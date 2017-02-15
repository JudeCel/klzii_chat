import React from 'react';
import { DropdownButton, MenuItem, OverlayTrigger, Popover, Button } from 'react-bootstrap';

const ButtonsWidth = React.createClass({
  setWidth(width) {
    this.props.setWidth(width);
  },
  render() {
    const widths = [6, 4, 2];
    const { strokeWidth } = this.props;
    return (
      <OverlayTrigger ref='zoom' trigger='click' rootClose placement='top' overlay={
          <Popover id='wb-buttons-width'>
            {
              widths.map((value) =>
                  <OverlayTrigger key={value} placement='top' overlay={ this.props.tooltipFormat(value) }>
                    <div className="btn btn-default" onClick={ this.setWidth.bind(this, value) }>{value}</div>
                  </OverlayTrigger>
              )
            }
          </Popover>
        }>
        <Button className={ 'btn btn-default' }>
          {strokeWidth} <i className='fa fa fa-cog' aria-hidden='true' />
        </Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsWidth;
