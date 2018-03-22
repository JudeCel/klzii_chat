import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import mixins             from '../../mixins';
import ToggleButton       from 'react-toggle-button';

const Toogle = React.createClass({
  mixins: [mixins.validations],
  getInitialState() {
    return { value: true };
  },
  changeState() {
    const { value } = this.state;
    this.setState({
      value: !value,
    });
    
  },
  render() {
    const { data, currentUser } = this.props;
    
    if (this.isFacilitator(currentUser)) {
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
    currentUser: state.members.currentUser
  };
};

export default connect(mapStateToProps)(Toogle);
