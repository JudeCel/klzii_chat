import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';

const Loading = React.createClass({

  render() {
    const { modalWindows } = this.props;

    if(modalWindows.postData) {
      return (
        <i className="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
      )
    }
    else {
      return (false)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
  }
};

export default connect(mapStateToProps)(Loading);
