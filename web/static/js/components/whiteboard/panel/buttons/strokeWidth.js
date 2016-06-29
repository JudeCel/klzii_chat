import React, {PropTypes} from 'react';

const LineButton = React.createClass({
  onClick() {
    const { changeButton, width } = this.props;
    changeButton({ strokeWidth: width });
  },
  render() {
    return (
      <i className='btn btn-default fa' aria-hidden='true' onClick={ this.onClick }>{ this.props.width }/</i>
    )
  }
});

export default LineButton;
