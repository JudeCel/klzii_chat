import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const ReportIcon = React.createClass({
  selectCorrectClassName(status, className) {
    const size = ' fa-2x';
    const pointer = ' cursor-pointer';

    switch (status) {
      case 'progress':
        return 'fa fa-spinner fa-pulse fa-fw' + size;
      case 'completed':
        return 'fa fa-download' + size + pointer;
      case 'failed':
        return 'fa fa-exclamation' + size + pointer;
      default:
        return className + size + pointer;
    }
  },
  selectCorrectFormat(status) {
    switch (this.props.format) {
      case 'pdf':
        return this.selectCorrectClassName(status, 'fa fa-file-pdf-o');
      case 'csv':
        return this.selectCorrectClassName(status, 'fa fa-file-excel-o');
      case 'txt':
        return this.selectCorrectClassName(status, 'fa fa-file-code-o');
    }
  },
  onClick(report) {
    switch (report.status) {
      case 'progress':
        return;
      case 'completed':
        return this.props.changePage('download', report);
      case 'failed':
        return this.props.changePage('failed', report);
      default:
        return this.props.createReport(report);
    }
  },
  getReport() {
    const { sessionTopicId, format, type, reports } = this.props;
    const flow = [sessionTopicId, format, type];

    let object = reports;
    for(var i = 0; i < flow.length; i++) {
      object = object[flow[i]];
      if(!object) break;
    }

    return object || {};
  },
  render() {
    const report = this.getReport();
    const { type, format, sessionTopicId, facilitator } = this.props;

    if(report.type == 'whiteboard' && report.format != 'pdf') {
      return (false);
    }
    else {
      return (
        <i className={ this.selectCorrectFormat(report.status) } onClick={ this.onClick.bind(this, { ...report, type, format, sessionTopicId, facilitator }) } />
      )
    }
  }
});

const mapStateToProps = (state) => {
  return {
    // enable later
    // reports: state.chat.session.reports
  }
};

export default connect(mapStateToProps)(ReportIcon);
