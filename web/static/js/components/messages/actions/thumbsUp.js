import React, { PropTypes, Component } from 'react';

class Delete extends Component {
  setClass() {
    let className = 'icon-thumbs-up';
    if(this.props.data.has_voted) { className += ' active'; }

    return className;
  }
  render() {
    const { id, votes_count } = this.props.data;
    const { can, onClick } = this.props;

    if(can) {
      return(
        <i className={ this.setClass() } onClick={ onClick } data-id={ id } >
          <small>{ votes_count }</small>
        </i>
      )
    }
    else{
      return(false)
    }
  }
}

export default Delete;
