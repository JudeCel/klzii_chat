import React, { PropTypes }       from 'react';

const Delete = ({data, can, onClick}) => {
  const { id } = data;
  if (can) {
    return(
      <div
        onClick={ onClick }
        data-id={ id }
        className="action glyphicon glyphicon-remove"
      />
    )
  }else{
    return(<div></div>)
  }
}
export default Delete;
