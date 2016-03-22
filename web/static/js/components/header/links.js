import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const Links = React.createClass({
  render() {
    const { colours } = this.props;
    const style = {
      backgroundColor: colours.headerButton
    };

    return (
      <div className='col-md-4 links-section'>
        <span className='links glyphicon glyphicon-comment' style={ style }></span>
        <span className='links glyphicon glyphicon-comment' style={ style }></span>
        <span className='links glyphicon glyphicon-comment' style={ style }></span>
        <span className='links glyphicon glyphicon-question-sign' style={ style }></span>
        <span className='links glyphicon glyphicon-off' style={ style }></span>
        <img width='40%' src='/images/logo.png' />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours
  };
};

export default connect(mapStateToProps)(Links);
