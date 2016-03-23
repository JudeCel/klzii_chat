import React, { PropTypes, Component }       from 'react';

class Reply extends Component {
  render(){
    const { id } = this.props.data;
    const { can, onClick } = this.props;
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
}
export default Reply;
