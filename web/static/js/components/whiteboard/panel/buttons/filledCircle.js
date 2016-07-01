import React, {PropTypes} from 'react';

const FilledCircleButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent, parent } = this.props;

    parent.hide();
    changeButton({ mode: 'filledCircle' });
    setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('filledCircle') + 'btn btn-default fa fa-circle' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledCircleButton;
