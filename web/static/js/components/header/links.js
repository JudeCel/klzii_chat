import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const Links = React.createClass({
  render() {
    const { colours } = this.props;
    const style = {
      backgroundColor: colours.headerButton
    };

    return (
      <div>
        <div className='col-md-4 links-section'>
          <span className='icon-buttons icon-trash' style={ style }></span>
          <span className='icon-buttons icon-book-1' style={ style }></span>
          <span className='icon-buttons icon-message' style={ style }></span>
          <span className='icon-buttons icon-help' style={ style }></span>
          <span className='icon-buttons icon-reply' style={ style }></span>
        </div>
        <div className='col-md-2'>
          <img width='100%' src='/images/logo.png' />
        </div>
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
