import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../../../mixins';
import {OverlayTrigger, Tooltip }         from 'react-bootstrap'

const DeleteAllButton = React.createClass({
  mixins: [mixins.validations],
  onClick() {
    const { changeButton, parent } = this.props;

    parent.hide();
    changeButton({ data: { mode: 'deleteAll' } });
  },
  render() {
    const tooltip =(
      <Tooltip id="tooltip"><strong>Delete All</strong></Tooltip>
    );

    if(this.hasPermission(['whiteboard', 'can_erase_all'])) {
      return (
        <OverlayTrigger placement="top" overlay={tooltip}>
          <i className='btn btn-default fa fa-eraser' aria-hidden='true' onClick={ this.onClick } >*</i>
        </OverlayTrigger>
      )

    }else {
      return(false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
  }
};

export default connect(mapStateToProps)(DeleteAllButton);
