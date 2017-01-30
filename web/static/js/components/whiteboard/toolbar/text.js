import React       from 'react';
import { OverlayTrigger, Button, Popover } from 'react-bootstrap';

const ButtonsText = React.createClass({
  getInitialState() {
    return { buttonType: 'text' };
  },
  onClick(action) {
    if(action == 'remove') {
      this.refs.text.hide();
    }
    else if(this.refs.input.value.length) {
      this.refs.text.hide();
      this.props.setText(this.state.buttonType, this.refs.input.value);
    }
  },
  popoverInput() {
    return (
      <Popover id='wb-buttons-text' className='input-group'>
        <input ref='input' type='text' className='form-control no-border-radius' />
        <span onClick={ this.onClick.bind(this, 'accept') } className='input-group-addon no-border-radius cursor-pointer'>
          <i className='glyphicon glyphicon-ok' aria-hidden='true' />
        </span>
        <span onClick={ this.onClick.bind(this, 'remove') } className='input-group-addon no-border-radius cursor-pointer'>
          <i className='glyphicon glyphicon-remove' aria-hidden='true' />
        </span>
      </Popover>
    )
  },
  render() {
    return (
      <OverlayTrigger ref='text' trigger='click' placement='top' rootClose overlay={ this.popoverInput() }>
        <OverlayTrigger placement='top' overlay={ this.props.tooltipFormat('Add Text') }>
          <Button className={ this.props.getClassnameParent(this.state.buttonType) + 'btn btn-default' }>
            <i className='fa fa-font' aria-hidden='true' />
          </Button>
        </OverlayTrigger>
      </OverlayTrigger>
    )
  }
});

export default ButtonsText;
