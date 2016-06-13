import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReportsActions     from '../../../actions/reports';

const ReportsDownload = React.createClass({
  deleteReport(reportId) {
    const { channel, dispatch } = this.props;
    dispatch(ReportsActions.delete(channel, reportId));
  },
  render() {
    const { report } = this.props;

    return (
      <div className='download-section'>
        <div className='col-md-12 text-center'>
          <h3>{ report.resource.name }</h3>
        </div>

        <div className='col-md-6 text-center'>
          <a href={ report.resource.url.full } target='_blank' download>
            <i className='fa fa-download' />
            <br />
            Download
          </a>
        </div>

        <div className='col-md-6 text-center'>
          <span className='cursor-pointer' onClick={ this.deleteReport.bind(this, report.id) }>
            <i className='fa fa-times' />
            <br />
            Remove
          </span>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.chat.channel
  }
};

export default connect(mapStateToProps)(ReportsDownload);
