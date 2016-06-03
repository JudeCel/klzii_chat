import React, {PropTypes}           from 'react';
import { connect }                  from 'react-redux';
import Actions                      from '../../actions/currentInput';
import { DropdownButton, MenuItem } from 'react-bootstrap';

const EmotionPicker = React.createClass({
  onSelectEmotion(emotionId) {
    this.props.dispatch(Actions.changeEmotion(emotionId));
  },
  buttonStyle() {
    return {
      backgroundColor: this.props.currentColour
    };
  },
  onMouseEnter(e) {
    e.currentTarget.style.backgroundColor = this.props.currentColour;
  },
  onMouseLeave(e) {
    e.currentTarget.style = {};
  },
  render() {
    const { currentEmotion } = this.props;
    const emotionIds = [0, 1, 2, 3, 4, 5].filter(item => item != currentEmotion);

    return (
      <DropdownButton title='' noCaret dropup
        className={ 'no-border-radius emotion-chat-' + currentEmotion }
        style={ this.buttonStyle() }
        id='emotion-selector'
      >
        {
          emotionIds.map((emotionId) => {
            return (
              <MenuItem
                key={ emotionId }
                onMouseEnter={ this.onMouseEnter }
                onMouseLeave={ this.onMouseLeave }
                onSelect={ this.onSelectEmotion.bind(this, emotionId) }
              >
                <div className={ 'emotion-chat-' + emotionId } />
              </MenuItem>
            )
          })
        }
      </DropdownButton>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    currentEmotion: state.currentInput.emotion,
    currentColour: state.members.currentUser.colour
  }
};

export default connect(mapStateToProps)(EmotionPicker);
