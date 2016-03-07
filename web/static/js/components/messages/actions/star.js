import React, { PropTypes }       from 'react';

const Star = ({data, can, onClick}) => {
  const { id, star } = data;
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
export default Star;
