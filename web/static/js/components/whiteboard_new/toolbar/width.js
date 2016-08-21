import React from 'react';
import { DropdownButton, MenuItem } from 'react-bootstrap';

const ButtonsWidth = React.createClass({
  render() {
    const widths = [6, 4, 2];
    const { strokeWidth } = this.props;

    return (
      <DropdownButton title={ strokeWidth } dropup noCaret className='fa fa-cog' id='wb-buttons-width'>
        {
          widths.map((value) =>
            <MenuItem key={ value } eventKey={ value } active={ strokeWidth == value } onSelect={ this.props.setWidth } >{ value }</MenuItem>
          )
        }
      </DropdownButton>
    )
  }
});

export default ButtonsWidth;
