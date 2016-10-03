import React, { PropTypes } from 'react';
import { connect }          from 'react-redux';
import Constants            from '../../../constants';

const EditMessage = React.createClass({
  editMessage() {
    const { message, dispatch } = this.props;
    dispatch({ type: Constants.SET_INPUT_EDIT, id: message.id, value: message.body, emotion: message.emotion });
  },
  render() {
    const { permission } = this.props;

    if(permission) {
      return(
        <i className='icon-pencil' onClick={ this.editMessage } />
      )
    }
    else {
      return(false)
    }
  }
});

const mapStateToProps = (state) => {
  return {};
};

export default connect(mapStateToProps)(EditMessage);
