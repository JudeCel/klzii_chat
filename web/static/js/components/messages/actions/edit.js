import React, { PropTypes, Component }       from 'react';

class Edit extends Component {
  render() {
    const { id, body } = this.props.data;
    const { can, onClick } = this.props;
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
}
export default Edit;
