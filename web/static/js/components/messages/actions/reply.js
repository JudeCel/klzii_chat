import React, { PropTypes }       from 'react';

const Reply = ({data, can, onClick}) => {
  const { id } = data
  if (can) {
    return(
      <div
        onClick={ onClick }
        data-replyid={ id }
        className="action glyphicon glyphicon-comment col-md-1"
        />
    )
  }else{
    return(false)
  }
}
export default Reply;
