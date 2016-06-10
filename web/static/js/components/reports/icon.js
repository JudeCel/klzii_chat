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
  onClick(status) {
    switch (status) {
      case 'progress':
        return;
      case 'completed':
        return;
      case 'failed':
        return;
      default:
        return this.props.createReport(this.props);
    }
  },
  getReportStatus() {
    const { sessionTopicId, format, type, reports } = this.props;
    const flow = [sessionTopicId, format, type];

    let object = reports;
    for(var i = 0; i < flow.length; i++) {
      object = object[flow[i]];
      if(!object) break;
    }

    return object && object.status;
  },
  render() {
    const status = this.getReportStatus();
    const { type, format } = this.props;

    if(type == 'whiteboard' && format != 'pdf') {
      return (false);
    }
    else {
      return (
        <i className={ this.selectCorrectFormat(status) } onClick={ this.onClick.bind(this, status) } />
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
