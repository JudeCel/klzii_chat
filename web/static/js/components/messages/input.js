import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import Actions            from '../../actions/currentInput';
import MessagesActions    from '../../actions/messages';

const Input = React.createClass({
  handleChange(e) {
    const { dispatch } = this.props;
    dispatch(Actions.changeValue(e.target.value));
  },
  sendMessage(e) {
    const { topicChannel, currentInput, dispatch } = this.props;

    if((e.charCode == 13 && e.target.value.length > 0)) {
      dispatch(MessagesActions.sendMessage(topicChannel, currentInput));
    }
  },
  render() {
    const { value, action, permissions, inputPrefix } = this.props;

    if(permissions && permissions.events.can_new_message) {
      return (
        <div className='input-section'>
          <div className='form-group'>
            <div className='input-group input-group-lg'>
              <div className='input-group-addon no-border-radius'>{ inputPrefix }</div>
              <input
                onKeyPress={ this.sendMessage }
                value={ value }
                type='text'
                onChange={ this.handleChange }
                className='form-control'
                placeholder='Message'
                />
              <div className='input-group-addon no-border-radius'><span className='fa fa-paper-plane'></span></div>
              <div className='input-group-addon no-border-radius'>POST</div>
              <div className='input-group-addon addon-invisible no-border-radius'><span className='fa fa-smile-o'></span></div>
            </div>
          </div>
        </div>
      )
    }
    else {
      return (<div></div>)
    }
  }
});

const mapStateToProps = (state) => {
  return {
    action: state.currentInput.action,
    permissions: state.members.currentUser.permissions,
    currentInput: state.currentInput,
    value: state.currentInput.value,
    topicChannel: state.topic.channel,
    inputPrefix: state.currentInput.inputPrefix,
  }
};

export default connect(mapStateToProps)(Input);
