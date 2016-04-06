import React, {PropTypes} from 'react';
import Member             from './member.js';
import { connect }        from 'react-redux';

const Participants = React.createClass({
  evenClasses(even) {
    const className = 'cursor-pointer ';
    return className + (even ? 'avatar-even' : 'avatar-odd');
  },
  render() {
    const { participants, colours, openAvatarModal } = this.props;

    //helper for testing
    for(let i of Array(7).keys()) {
      if(participants[0]) {
        let last = participants.length-1;
        let object = Object.assign({}, participants[last]);
        object.id += 10;
        participants.push(object);
      }
    }

    return (
      <div className='participants-section remove-side-margin'>
        {
          participants.map((participant, index) =>
            <div className='col-md-3' key={ participant.id }>
              <div className={ this.evenClasses(index % 2 == 0) } onClick={ openAvatarModal }>
                <Member member={ participant } colour={ colours.participants[index+1] } />
              </div>
            </div>
          )
        }
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    participants: state.members.participants,
    colours: state.chat.session.colours
  }
};

export default connect(mapStateToProps)(Participants);
