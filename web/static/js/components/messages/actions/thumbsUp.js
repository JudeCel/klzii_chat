import React, { PropTypes, Component }       from 'react';


class Delete extends Component {
  render(){
    const { id, votes_count, has_voted } = this.props.data;
    const { can, onClick } = this.props;
    if (can) {
      return(
        <div
          onClick={ onClick }
          data-id={ id }
          className="action glyphicon glyphicon-thumbs-up col-md-1" style={{ color: ( has_voted ? "green" : "") }} >
          { votes_count }
        </div>
      )
    }else{
      return(false)
    }
  }
}

export default Delete;
