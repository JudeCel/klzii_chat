import React, {PropTypes} from 'react';

const NoneButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent } = this.props;

    changeButton({ mode: 'none' });
    setActiveParent();
  },
  render() {
    return (
      <button className={ this.props.activeClass('none') + 'btn btn-default' } onClick={ this.onClick }>
        <i className='fa fa-hand-paper-o' aria-hidden='true' />
      </button>
    )
  }
});

export default NoneButton;
