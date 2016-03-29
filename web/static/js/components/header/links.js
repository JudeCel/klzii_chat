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
          <ul className='icons'>
            <li style={ style }>
              <i className='icon-trash' />
            </li>
            <li style={ style }>
              <i className='icon-book-1' />
            </li>
            <li style={ style }>
              <i className='icon-message' />
            </li>
            <li style={ style }>
              <i className='icon-help' />
            </li>
            <li style={ style }>
              <i className='icon-reply' />
            </li>
          </ul>
        </div>
        <div className='col-md-2 logo-section'>
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
