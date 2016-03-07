import React, { PropTypes }       from 'react';

const Edit = ({data, can, onClick}) => {
  const { id, body } = data;
  if (can) {
    return(
      <div
        onClick={ onClick }
        data-id={ id }
        data-body={ body }
        className="action glyphicon glyphicon-edit col-md-1"
        />
    )
  }else{
    return(false)
  }
}
export default Edit;
