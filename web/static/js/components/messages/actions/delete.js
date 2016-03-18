import React, { PropTypes, Component }       from 'react';


class Delete extends Component {
  render(){
    const { id } = this.props.data;
    const { can, onClick } = this.props;
    if (can) {
      return(
        <div
          onClick={ onClick }
          data-id={ id }
          className="action glyphicon glyphicon-remove col-md-1"
        />
      )
    }else{
      return(false)
    }
  }
}

export default Delete;
