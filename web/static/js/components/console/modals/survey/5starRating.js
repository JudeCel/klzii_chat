import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Rating             from 'react-rating';

const AnswerYesNoMaybe = React.createClass({
  getInitialState() {
    return { checked: 0 };
  },
  onChange(value) {
    this.setState({ checked: value });
    this.props.afterChange(value);
  },
  render() {
    const { checked } = this.state;
    const { survey } = this.props;

    return (
      <div className='col-md-12'>
        <div className='text-center'>
          { survey.question }
        </div>

        <div className='text-center star-rating-section'>
          <Rating onChange={ this.onChange } placeholder='fa fa-star' empty='fa fa-star-o' full='fa fa-star' placeholderRate={ checked } />
        </div>
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
