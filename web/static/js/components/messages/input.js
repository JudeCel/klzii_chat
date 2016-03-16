import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Actions            from '../../actions/currentInput';
import MessagesActions    from '../../actions/messages';

const Input =  React.createClass({
  handleChange(e){
    this.props.dispatch(Actions.changeValue(e.target.value));
  },
  sendMessage(e){
    if ((e.charCode == 13 && e.target.value.length > 0)) {
      this.props.dispatch(MessagesActions.sendMessage(this.props.topicChannal, this.props.currentInput));
    }
  },
  render(){
    const { value, action, permissions, inputPrefix} = this.props;
    if (permissions && permissions.events.can_new_message) {
      return (
        <div className="form-group col-md-12">
          <div className="input-group">
            <div className="input-group-addon">{ inputPrefix }</div>
            <input
              onKeyPress={ this.sendMessage }
              value={ value }
              type="text"
              onChange={ this.handleChange }
              className="form-control"
              placeholder="Message"
              />
          </div>
        </div>
      );
    }else {
      return (<div></div>)
    }
  }
})
const mapStateToProps = (state) => {
  return {
    action: state.currentInput.action,
    permissions: state.members.currentUser.permissions,
    currentInput: state.currentInput,
    value: state.currentInput.value,
    topicChannal: state.topic.channel,
    inputPrefix: state.currentInput.inputPrefix,
  }
};
export default connect(mapStateToProps)(Input);
