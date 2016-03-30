import React, { PropTypes, Component } from 'react';

class Star extends Component {
  setClass() {
    let className = 'icon-star';
    if(!this.props.data.star) { className += '-empty'; }

    return className;
  }
  render() {
    const { id } = this.props.data;
    const { can, onClick } = this.props;

    if(can) {
      return(
        <i className={ this.setClass() } onClick={ onClick } data-id={ id } />
      )
    }
    else {
      return(false)
    }
  }
}

export default Star;
