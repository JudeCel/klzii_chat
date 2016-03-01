import React, { PropTypes }       from 'react';

const Delete = ({data, can, onClick}) => {
  const { id, votes_count, has_voted } = data;
  if (can) {
    return(
      <div
        onClick={ onClick }
        data-id={ id }
        className="action glyphicon glyphicon-thumbs-up" style={{ color: ( has_voted ? "green" : "") }} >
        { votes_count }
      </div>
    )
  }else{
    return(<div></div>)
  }
}
export default Delete;