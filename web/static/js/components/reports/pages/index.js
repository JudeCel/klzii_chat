import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReportIcon         from './../helpers/icon';
import ReportsActions     from '../../../actions/reports';

const ReportsIndex = React.createClass({
  getInitialState() {
    return { format: 'pdf', facilitator: true };
  },
  onChange(key, value) {
    this.setState({ [key]: value });
  },
  createReport(params) {
    const { channel, dispatch } = this.props;
    const { sessionTopicId, format, type, facilitator } = params;

    dispatch(ReportsActions.create(channel, { sessionTopicId, format, type, facilitator }));
  },
  componentDidMount() {
    const { channel, dispatch } = this.props;
    dispatch(ReportsActions.index(channel));
  },
  render() {
    const { sessionTopics, reports, changePage } = this.props;
    const { format, facilitator } = this.state;
    const reportFormats = ['pdf', 'csv', 'txt'];
    const reportTypes = ['all', 'star', 'whiteboard', 'votes'];
    const colMdSizes = [2, 3, 3, 1];

    return (
      <div className='reports-section'>
        <ul className='list-inline'>
          {
            reportFormats.map((reportFormat, index) =>
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
        <label htmlFor={ 'report-type-00' }>Include Facilitator Interaction</label>

        <table className={ 'table table-hover view-' + format }>
          <thead>
            <tr>
              <th>Topics</th>
              <th>All</th>
              <th>Chat Room History<br /> Stars Only</th>
              <th>Whiteboard</th>
              <th>Votes</th>
            </tr>
          </thead>
          <tbody>
            {
              sessionTopics.map((topic, tIndex) =>
                <tr key={ topic.id }>
                  <td className='col-md-3'>{ topic.name }</td>
                  {
                    reportTypes.map((type, fIndex) =>
                      <td className={ 'col-md-' + colMdSizes[fIndex] } key={ fIndex }>
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
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    sessionTopics: state.chat.session.session_topics,
    channel: state.chat.channel,
    reports: state.reports.data
  }
};

export default connect(mapStateToProps)(ReportsIndex);
