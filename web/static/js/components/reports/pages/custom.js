import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import ReportsActions      from '../../../actions/reports';
import NotificationActions from '../../../actions/notifications';

const ReportsCustom = React.createClass({
  onDownload() {

    const customFields = Object.keys(this.state.selected);
    const { dispatch } = this.props
    const report = {...this.props.report, customFields: customFields};
    dispatch(ReportsActions.create(this.props.channel, report));
    this.props.changePage('index', this.props.report);
  },
  onActivate(field, e) {
    const { selected } = this.state;
    const { mapStruct } = this.props
    const selectedCount = Object.keys(selected).length;

    if(e.target.checked) {
      if(selectedCount >= mapStruct.max_default_fileds_count) {
        e.target.checked = false;
        this.setState({ limitReached: true });
      }
      else {
        selected[field] = true;
        this.setState({ limitReached: false, selected });
      }
    }
    else {
      delete selected[field];
      this.setState({ selected, limitReached: (selectedCount-1) >= mapStruct.max_default_fileds_count });
    }
  },
  showDefaultColumns() {
    const { mapStruct, report } = this.props;
    let structData = mapStruct.types[report.type];
    return structData.defaultFields.join(", ");
  },
  getInitialState() {
    return { selected: {}, limitReached: false };
  },
  componentDidMount() {
    this.componentDidUpdate();
  },
  componentDidUpdate(props, state) {
    const { mapStruct, dispatch, reference } = this.props
    reference.title.innerText = 'Manage Columns in View';
    if(this.state.limitReached && state.limitReached != this.state.limitReached) {
      let errorMessage = `You can select not more than ${mapStruct.max_default_fileds_count} additional custom fields in your report`;
      NotificationActions.showErrorNotification(dispatch, [errorMessage]);
    }
  },
  render() {
    const { limitReached } = this.state;
    const { mapStruct } = this.props;

    return (
      <div className='custom-fields-section'>
        <div>Your report will include the following default Columns:</div>
        <div><strong>{ this.showDefaultColumns() }</strong></div>
        <br />
        <div>You can also select up to {mapStruct.max_default_fileds_count} additional Columns</div>

        <div>
          {mapStruct.fields.custom.map((field, index) =>
            <div key={ index } className='col-xs-12 col-sm-3'>
              <input id={ 'field-input-' + index } type='checkbox' className='with-font' onClick={ this.onActivate.bind(this, field) } />
              <label htmlFor={ 'field-input-' + index }>{ field }</label>
            </div>
          )}
        </div>

        <div className='col-xs-12'>
          <div className='no-border-radius pull-right btn-standart btn-green' onClick={ this.onDownload }>
            Download
          </div>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    channel: state.chat.channel
  };
};

export default connect(mapStateToProps)(ReportsCustom);
