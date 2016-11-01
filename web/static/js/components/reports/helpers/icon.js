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
        if(this.shouldShowCustomFields()) {
          this.props.changePage('selectCustom', { type: this.props.type.name });
        }
        else {
          return this.props.createReport(report);
        }
    }
  },
  shouldShowCustomFields() {
    const { type, format, mapStruct } = this.props;

    let structData = mapStruct.types[type.name];
    return (format == 'txt' || format == 'csv') && structData.formats[format].render;
  },
  getReport() {
    const { type, format, sessionTopicId, facilitator, reports } = this.props
    const flow = [sessionTopicId, format, type.typeName];

    let object = {...reports};
    for(var i = 0; i < flow.length; i++) {
      object = object[flow[i]];
      if(!object) break;
    }

    if (object) {
      return object;
    }else {
      return {
        scopes: type.scopes,
        format: format,
        type: type.typeName,
        sessionTopicId: this.props.sessionTopicId,
          includes: { facilitator: facilitator }
      }
    }
  },
  render() {
    let { type, format } = this.props
    const report = this.getReport();
    if(type.typeData.formats[format].render) {
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
