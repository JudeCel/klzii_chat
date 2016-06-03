import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const ReportsIndex = React.createClass({
  getInitialState() {
    return { type: 'pdf', interaction: true }
  },
  onChange(key, type) {
    this.setState({ [key]: type });
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
    switch (this.state.type) {
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
  createReport(category, topicId) {
    console.error(category, topicId, this.state);
  },
  render() {
    const { sessionTopics } = this.props;
    const { type, interaction } = this.state;
    const reportTypes = ['pdf', 'csv', 'txt'];
    const reportCategory = ['all', 'history', 'whiteboard', 'votes'];

    return (
      <div>
        <ul className='list-inline'>
          {
            reportTypes.map((report, index) =>
              <li key={ index }>
                <input id={ 'report-type-' + index }
                  name='active' type='radio' className='with-font'
                  onChange={ this.onChange.bind(this, 'type', report) }
                  defaultChecked={ type == report } />
                <label className='text-uppercase' htmlFor={ 'report-type-' + index }>{ report }</label>
              </li>
            )
          }
        </ul>

        <input id={ 'report-type-00' }
          name='active' type='checkbox' className='with-font'
          onChange={ this.onChange.bind(this, 'interaction', !interaction) }
          defaultChecked={ interaction } />
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
                <tr key={ tIndex }>
                  <td>{ topic.name }</td>
                  {
                    reportCategory.map((category, fIndex) =>
                      <td key={ fIndex }>
                        <i className={ this.selectCorrectTypeIcon() } onClick={ this.createReport.bind(this, category, topic.id) } />
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
  }
};

export default connect(mapStateToProps)(ReportsIndex);
