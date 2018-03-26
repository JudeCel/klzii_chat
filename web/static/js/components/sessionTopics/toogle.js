import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import ToggleButton       from 'react-toggle-button';

const Toogle = React.createClass({
  mixins: [mixins.headerActions, mixins.validations],
  getInitialState() {
    const { sessionTopic } = this.props;
    return { value: sessionTopic.active };
  },
  changeState() {
    const { value } = this.state;
    const { sessionTopic } = this.props;
    let newValue = !value;

    this.setSessionTopicActive(sessionTopic.id, newValue);
    this.setState({ value: newValue });
  },
  render() {
    const { currentUser, sessionTopic } = this.props;
    
    if (!sessionTopic.inviteAgain && this.isFacilitator(currentUser)) {
      return (
        <ToggleButton
          thumbStyle={{ borderRadius: 2 }}
          trackStyle={{ borderRadius: 2, width:'60px' }}
          containerStyle={{display:'inline-block',width:'60px'}} 
          thumbAnimateRange={[0, 41]} 
          activeLabelStyle={{ width:'30px' }} 
          inactiveLabelStyle={{ width:'30px', color: '#111' }}
          inactiveLabel={"HIDE"}
          activeLabel={"SHOW"}
          colors={{
            active: {
              base: '#428bca',
              hover: '#428bca',
            },
            inactive: {
              base: '#EEEEEE',
              hover: '#EEEEEE',
            }
          }}
          value={ this.state.value || false }
          onToggle={ this.changeState }
        />
      )
    } else {
      return null;
    }
  }
});

const mapStateToProps = (state) => {
  return {
    currentUser: state.members.currentUser,
    channel: state.sessionTopic.channel,
  };
};

export default connect(mapStateToProps)(Toogle);
