import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import _                  from 'lodash';
import mixins             from '../../../mixins';

const ReportIcon = React.createClass({
  mixins: [mixins.validations],
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
  selectCorrectFormat(status, enabled) {
    const classStatus = enabled ? " enable" : " disabled";

    switch (this.props.format) {
      case 'pdf':
        return this.selectCorrectClassName(status, 'fa fa-file-pdf-o' + classStatus);
      case 'csv':
        return this.selectCorrectClassName(status, 'fa fa-file-excel-o' + classStatus);
      case 'txt':
        return this.selectCorrectClassName(status, 'fa fa-file-code-o' + classStatus);
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
    const report = _.get(reports, flow, tmpObject);
    const permission = this.hasPermission(['reports', 'can_report']);
    report.enabled = permission;

    if (type.typeName == "prize_draw"){
      report.enabled = true;
    }

    return report;
  },
  canRender(type, topic, format){
    if (type.typeName == "prize_draw") {
      return (type.formats[format].render && topic.inviteAgain)
    }else{
      return type.formats[format].render
    }
  },
  render() {
    let { type, format, topic } = this.props

    if(this.canRender(type, topic, format)) {
      const report = this.getReport();
      return (
        <i className={ this.selectCorrectFormat(report.status, report.enabled)} onClick={ this.onClick.bind(this, report) } />
      )
    }
    else {
      return (false);
    }
  }
});

const mapStateToProps = (state) => {
  return {
    reports: state.reports.data,
    currentUser: state.members.currentUser
  }
};

export default connect(mapStateToProps)(ReportIcon);
