import React, { PropTypes, Component }       from 'react';


class Star extends Component {
  render(){
    const { id, star } = this.props.data;
    const { can, onClick } = this.props;
    if (can) {
      return(
        <div className={"star " + (star ? "active" : "") + " glyphicon glyphicon-star col-md-1" }
          onClick={ onClick }
          data-id={ id }
          />
      )
    }else{
      return(false)
    }
  }
}

export default Star;
