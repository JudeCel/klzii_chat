import React, {PropTypes}  from 'react';
import { connect }         from 'react-redux';
import ReportsActions      from '../../../actions/reports';
import NotificationActions from '../../../actions/notifications';

const MAX_CUSTOM_FIELDS = 4;

const ReportsCustom = React.createClass({
  onDownload() {
    let customFields = Object.keys(this.state.selected);
    ReportsActions.csvWithCustomFields(this.props.channel, customFields);
  },
  onActivate(field, e) {
    const { selected } = this.state;

    let selectedCount = Object.keys(selected).length;
    if(e.target.checked) {
      if(selectedCount >= MAX_CUSTOM_FIELDS) {
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
      this.setState({ selected, limitReached: (selectedCount-1) >= MAX_CUSTOM_FIELDS });
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
    this.props.reference.title.innerText = 'Manage Columns in View';
    if(this.state.limitReached && state.limitReached != this.state.limitReached) {
      let errorMessage = `You can select not more than ${MAX_CUSTOM_FIELDS} additional custom fields in your report`;
      NotificationActions.showErrorNotification(this.props.dispatch, [errorMessage]);
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
        <div>You can also select up to 4 additional Columns</div>

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
