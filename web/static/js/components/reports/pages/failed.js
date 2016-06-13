import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReportsActions     from '../../../actions/reports';

const ReportsDownload = React.createClass({
  deleteReport(reportId) {
    const { channel, dispatch } = this.props;
    dispatch(ReportsActions.delete(channel, reportId));
  },
  recreateReport(reportId) {
    const { channel, dispatch } = this.props;
    dispatch(ReportsActions.recreate(channel, reportId));
  },
  render() {
    const { report } = this.props;

    return (
      <div className='download-section'>
        <div className='col-md-12 text-center'>
          <h3>Something went wrong with this report</h3>
        </div>

        <div className='col-md-6 text-center'>
          <span className='cursor-pointer' onClick={ this.recreateReport.bind(this, report.id) }>
            <i className='fa fa-refresh' />
            <br />
            Try again
          </span>
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
