import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Actions      from '../../actions/topic';

const Select =  React.createClass({
  changeTopic(e){
    let id = e.target.selectedOptions[0].value;
    this.props.dispatch(Actions.changeTopic(this.props.channal, id));
  },
  render() {
    const { current } = this.props
    return (
      <div>
        <select onChange={ this.changeTopic } defaultValue={current.id} >
          {
            this.props.topics.map((t) =>{
              return(
                <option
                  key={ t.id }
                  value={ t.id }>
                  { t.name }
                </option>
              )
            })
          }
        </select>
      </div>
    );
  }
})
const mapStateToProps = (state) => {
  return {
    channal: state.topic.channel,
    current: state.topic.current,
    topics: state.topic.all,
  }
};
export default connect(mapStateToProps)(Select);
