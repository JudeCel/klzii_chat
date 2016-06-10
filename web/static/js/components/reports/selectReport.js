import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import ReportsActions     from '../../actions/reports';

const ReportsIndex = React.createClass({
  getInitialState() {
    return { format: 'pdf', facilitator: true }
  },
  onChange(key, value) {
    this.setState({ [key]: value });
  },
  shouldShowLoading(color, className) {
    // Needs correct check
    if(this.props.loading) {
      return `${ color } fa fa-spinner fa-pulse fa-2x fa-fw`;
    }
    else {
      return `${ color } ${ className }`;
    }
  },
  selectCorrectTypeIcon() {
    switch (this.state.format) {
      case 'pdf':
        return this.shouldShowLoading('font-color-red', 'cursor-pointer fa fa-file-pdf-o fa-2x');
        break;
      case 'csv':
        return this.shouldShowLoading('font-color-green', 'cursor-pointer fa fa-file-excel-o fa-2x');
        break;
      case 'txt':
        return this.shouldShowLoading('font-color-blue', 'cursor-pointer fa fa-file-code-o fa-2x');
        break;
      default:

    }
  },
  createReport(type, sessionTopicId) {
    const { channel, dispatch } = this.props;
    const { format, facilitator } = this.state;
    dispatch(ReportsActions.create(channel, { format, type, sessionTopicId, facilitator }));
  },
  render() {
    const { sessionTopics } = this.props;
    const { format, facilitator } = this.state;
    const reportFormats = ['pdf', 'csv', 'txt'];
    const reportTypes = ['all', 'star', 'whiteboard', 'votes'];

    return (
      <div>
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

        <table className='table table-hover'>
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
                  <td>{ topic.name }</td>
                  {
                    reportTypes.map((type, fIndex) =>
                      <td key={ fIndex }>
                        <i className={ this.selectCorrectTypeIcon() } onClick={ this.createReport.bind(this, type, topic.id) } />
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
    channel: state.chat.session.channel
  }
};

export default connect(mapStateToProps)(ReportsIndex);
