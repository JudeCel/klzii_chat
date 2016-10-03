import React, {PropTypes} from 'react';
import { OverlayTrigger, Tooltip }         from 'react-bootstrap'


const NoneButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent } = this.props;

    changeButton({ mode: 'none' });
    setActiveParent();
  },
  render() {
    const tooltip =(
      <Tooltip id="tooltip"><strong>Move</strong></Tooltip>
    );
    return (
      <OverlayTrigger placement="top" overlay={tooltip}>
        <button className={ this.props.activeClass('none') + 'btn btn-default' } onClick={ this.onClick }>
          <i className='fa fa-hand-paper-o' aria-hidden='true' />
        </button>
      </OverlayTrigger>
    )
  }
});

export default NoneButton;
