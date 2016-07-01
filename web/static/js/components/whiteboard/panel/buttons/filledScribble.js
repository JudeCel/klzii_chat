import React, {PropTypes} from 'react';

const FilledScribbleButton = React.createClass({
  onClick() {
    const { changeButton, setActiveParent, parent } = this.props;

    parent.hide();
    changeButton({ mode: 'filledScribble' });
    setActiveParent();
  },
  render() {
    return (
      <i className={ this.props.activeClass('filledScribble') + 'btn btn-default fa fa fa-bookmark' } aria-hidden='true' onClick={ this.onClick } />
    )
  }
});

export default FilledScribbleButton;
