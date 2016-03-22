import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Actions            from '../../actions/topic';

const Select = React.createClass({
  changeTopic(e) {
    const { dispatch, channel } = this.props;

    let id = e.target.selectedOptions[0].value;
    dispatch(Actions.changeTopic(channel, id));
  },
  render() {
    const { current, topics, session } = this.props;

    return (
      <div className='col-md-3 topic-select-section'>
        <div>
          { session.name }
        </div>
        <select onChange={ this.changeTopic } defaultValue={ current.id }>
          {
            topics.map((topic) => {
              return (
                <option key={ topic.id } value={ topic.id }>
                  { topic.name }
                </option>
              )
            })
          }
        </select>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    session: state.chat.session,
    channel: state.topic.channel,
    current: state.topic.current,
    topics: state.topic.all,
  };
};

export default connect(mapStateToProps)(Select);
