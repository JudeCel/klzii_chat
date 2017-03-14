import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import _                  from 'lodash';

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
        if(this.shouldShowCustomFields()) {
          this.props.changePage('selectCustom', report);
        }
        else {
          return this.props.createReport(report);
        }
    }
  },
  shouldShowCustomFields() {
    const { type, format } = this.props;

    return type.formats[format].custom_fields && type.formats[format].render;
  },
  getReport() {
    const { type, format, sessionTopicId, facilitator, reports } = this.props
    let flow = [sessionTopicId, format, type.typeName];

    const tmpObject = {
      format: format,
      type: type.typeName,
      sessionTopicId: sessionTopicId == "all" ? null : sessionTopicId,
        includes: { facilitator: facilitator }
    }

    if (type.name == "statistic") {
      flow = ["statistic", format, type.typeName];
    }

    return _.get(reports, flow, tmpObject);

  },
  render() {
    let { type, format } = this.props
    const report = this.getReport();
    
    if(type.formats[format].render) {
      return (
        <i className={ this.selectCorrectFormat(report.status) } onClick={ this.onClick.bind(this, report) } />
      )
    }
    else {
      return (false);
    }
  }
});

const mapStateToProps = (state) => {
  return {
    reports: state.reports.data
  }
};

export default connect(mapStateToProps)(ReportIcon);
