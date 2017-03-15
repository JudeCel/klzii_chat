import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReportIcon         from './../helpers/icon';
import ReportsActions     from '../../../actions/reports';

const ReportsIndex = React.createClass({
  getInitialState() {
    const { reports, report } = this.props
    return { format: ((report && report.format) || 'pdf'), facilitator: reports.mapStruct.includes.facilitator };
  },
  onChange(key, value) {
    this.setState({ [key]: value });
  },
  createReport(params) {
    const { channel, dispatch } = this.props;

    dispatch(ReportsActions.create(channel, params ));
  },
  componentDidMount() {
    const { channel, dispatch } = this.props;
    dispatch(ReportsActions.index(channel));
  },
  statisticReport(){
    const { reports, mapStruct, changePage } = this.props;
    const { format, facilitator } = this.state;
    let type = {...mapStruct.types.statistic}
    type.typeName = "statistic"
    if (mapStruct.types.statistic.formats[format].render) {
      return(
        <div className="chat-room-statistics">
          <div className="title">
            Chat Room Statistics
          </div>
          <div className="report-icon">
            <ReportIcon
              { ...{ format, type, facilitator, sessionTopicId: null } }
              { ...{ createReport: this.createReport, changePage: changePage, mapStruct: mapStruct } }
            />
          </div>
        </div>
      )
    }else{
      return ""
    }
  },
  buildReportTypes(types, session){
    const sessionType = session.type;
    const reportTypes = [];

    for (let value of Object.keys(types)) {
      let type = types[value];
      if (type.session_types.indexOf(sessionType) > -1 && type.section == "table") {
        type.typeName = value;
        reportTypes.push(type);
      }
    }
    return reportTypes.sort((a, b) => {
      return a.position - b.position;
    });
  },
  render() {
    const { sessionTopics, reports, changePage, mapStruct, session } = this.props;
    const { types } = reports.mapStruct
    const { format, facilitator } = this.state;

    const reportFormatsOrder = ['pdf', 'csv', 'txt'];
    const reportTypes = this.buildReportTypes(types, session);
    let sessionTopicslist = [...sessionTopics.filter((i) => {return !i.default})];

    if (mapStruct.multiple_topics[format]) {
      sessionTopicslist.unshift({name: "All topics", id: "all"}); // Hack
    }

    const colMdSizes = { all: 2, star: 3, whiteboard: 3,  votes: 1 };
    return (
      <div className='reports-section'>
        <ul className='list-inline'>
          {
            reportFormatsOrder.map((reportFormat, index) =>
              <li key={ index }>
                <input id={ 'report-format-' + index }
                  name='active' type='radio' className='with-font'
                  onChange={ this.onChange.bind(this, 'format', reportFormat) }
                  defaultChecked={ format == reportFormat } />
                <label className='text-uppercase' htmlFor={ 'report-format-' + index }>{ reportFormat }</label>
              </li>
            )
          }
        </ul>

        <input id={ 'report-type-00' }
          name='active' type='checkbox' className='with-font'
          onChange={ this.onChange.bind(this, 'facilitator', !facilitator) }
          defaultChecked={ facilitator } />
        <label htmlFor={ 'report-type-00' }>Include Host Interaction</label>

        <table className={ 'table table-hover view-' + format }>
          <thead>
            <tr>
              <th>Topics</th>
              {
                reportTypes.map((item) =>
                <th key={item.position}><p>{item.name}</p></th>
              )
              }
            </tr>
          </thead>
          <tbody>
            {
              sessionTopicslist.map((topic, tIndex) =>
                <tr key={ topic.id }>
                  <td className='col-md-3'>{ topic.name }</td>
                  {
                    reportTypes.map((type, fIndex) =>
                      <td className={ 'col-md-' + colMdSizes[type] } key={ fIndex }>
                        <ReportIcon
                          { ...{ format, type, facilitator, sessionTopicId: topic.id } }
                          { ...{ createReport: this.createReport, changePage: changePage } }
                        />
                      </td>
                    )
                  }
                </tr>
              )
            }
          </tbody>
        </table>
        <hr/>
        {this.statisticReport()}
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    sessionTopics: state.chat.session.session_topics,
    channel: state.chat.channel,
    session: state.chat.session,
    reports: state.reports
  }
};

export default connect(mapStateToProps)(ReportsIndex);
