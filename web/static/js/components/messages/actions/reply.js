import React, { PropTypes }       from 'react';

const Reply = ({data, can, onClick}) => {
  const { id } = data
  if (can) {
    return(
      <div
        onClick={ onClick }
        data-replyid={ id }
        className="action glyphicon glyphicon-comment"
        />
    )
  }else{
    return(<div></div>)
  }
}
export default Reply;
