import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Rating             from 'react-rating';

const SurveyView5StarRating = React.createClass({
  getAvarageCount() {
    const { answers } = this.props;
    let sum = answers.reduce((a, b) => { return a.value + b.value; });
    return sum / answers.length;
  },
  render() {
    const { answers } = this.props;
    return (
      <ul className='list-group'>
        <li key={ -1 } className='list-group-item'>
          <div className='row'>
            <div className='col-md-offset-3 col-md-9 star-rating-section text-right'>
              <Rating placeholder='fa fa-star' empty='fa fa-star-o' full='fa fa-star' initialRate={ this.getAvarageCount() } readonly={ true } />
            </div>
          </div>
        </li>
        {
          answers.map((answer, index) => {
            return (
              <li key={ index } className='list-group-item'>
                <div className='row'>
                  <div className='col-md-3'>{ answer.sessionMember.username }</div>
                  <div className='col-md-9 star-rating-section text-right'>
                    <Rating placeholder='fa fa-star' empty='fa fa-star-o' full='fa fa-star' initialRate={ answer.value } readonly={ true } />
                  </div>
                </div>
              </li>
            )
          })
        }
      </ul>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    answers: /*state.resources.survey.answers || */ [
      { id: 1, sessionMemberId: 1, value: 1, sessionMember: { username: 'Random 1' } },
      { id: 2, sessionMemberId: 2, value: 2, sessionMember: { username: 'Random 2' } }
    ]
  }
};

export default connect(mapStateToProps)(SurveyView5StarRating);
