import React from 'react';
import { OverlayTrigger, Button, Popover } from 'react-bootstrap';

const ButtonsDelete = React.createClass({
  onClick(all) {
    this.refs.delete.hide();
    this.props.setDelete(all);
  },
  render() {
    return (
      <OverlayTrigger ref='delete' trigger='click' rootClose placement='top' overlay={
          <Popover id='wb-buttons-delete'>
            <i className='btn btn-default fa fa-cube' aria-hidden='true' onClick={ this.onClick.bind(this, false) } />
            <i className='btn btn-default fa fa-cubes' aria-hidden='true' onClick={ this.onClick.bind(this, true) } />
          </Popover>
        }>

        <Button><i className='fa fa-trash' aria-hidden='true' /></Button>
      </OverlayTrigger>
    )
  }
});

export default ButtonsDelete;
