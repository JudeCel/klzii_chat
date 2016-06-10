import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import ReportsModal       from './../reports/modal';

const Links = React.createClass({
  mixins: [mixins.modalWindows, mixins.validations],
  reportsFunction(style) {
    // temp
    if(this.hasPermission(['reports', 'can_report']) || true) {
      return (
        <li style={ style } onClick={ this.openSpecificModal.bind(this, 'reports') }>
          <i className='icon-book-1' />
        </li>
      )
    }
  },
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
            { this.reportsFunction(style) }
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

        <ReportsModal show={ this.showSpecificModal('reports') } />
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    modalWindows: state.modalWindows,
    colours: state.chat.session.colours
  };
};

export default connect(mapStateToProps)(Links);
