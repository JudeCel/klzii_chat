import React, { PropTypes }       from 'react';

const Star = ({data, can, onClick}) => {
  const { id, star } = data;
  if (can) {
    return(
      <div className={"star " + (star ? "active" : "") + " glyphicon glyphicon-star " }
        onClick={ onClick }
        data-id={ id }
        />
    )
  }else{
    return(<div></div>)
  }
}
export default Star;
