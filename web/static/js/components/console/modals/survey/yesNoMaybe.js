import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';

const AnswerYesNoMaybe = React.createClass({
  getInitialState() {
    return { checked: 0 };
  },
  onChange(e) {
    let value = e.target.value;
    this.setState({ checked: value });
    this.props.afterChange(value);
  },
  render() {
    const { survey } = this.props;

    return (
      <div className='col-md-12'>
        <div className='text-center'>
          { survey.question }
        </div>

        <ul className='list-group'>
          <li className='list-group-item'>
            <input id='yesNoMaybe1' name='answer' value='1' type='radio' className='with-font' onChange={ this.onChange } />
            <label htmlFor='yesNoMaybe1'>Yes</label>
          </li>
          <li className='list-group-item'>
            <input id='yesNoMaybe2' name='answer' value='2' type='radio' className='with-font' onChange={ this.onChange } />
            <label htmlFor='yesNoMaybe2'>No</label>
          </li>
          <li className='list-group-item'>
            <input id='yesNoMaybe3' name='answer' value='3' type='radio' className='with-font' onChange={ this.onChange } />
            <label htmlFor='yesNoMaybe3'>Maybe</label>
          </li>
        </ul>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    survey: state.resources.survey || {id: 1, title: 'Survey', question: 'Do you like?', type: 'yesNoMaybe', active: true}
  }
};

export default connect(mapStateToProps)(AnswerYesNoMaybe);
