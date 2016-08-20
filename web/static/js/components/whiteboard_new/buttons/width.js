import React from 'react';
import { DropdownButton, MenuItem } from 'react-bootstrap';

const ButtonsWidth = React.createClass({
  getInitialState() {
    return { activeButton: null, buttonType: 'poly' };
  },
  render() {
    const widths = [2, 4, 6];

    return (
      <DropdownButton title={ this.props.strokeWidth || 2 } dropup noCaret className='fa fa-cog' id='wb-buttons-width'>
        {
          widths.map((value) =>
            <MenuItem key={ value } eventKey={ value } active={ this.props.strokeWidth == value }>{ value }</MenuItem>
          )
        }
      </DropdownButton>
    )
  }
});

export default ButtonsWidth;
