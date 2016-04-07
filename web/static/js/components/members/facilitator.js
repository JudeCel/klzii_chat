import React, {PropTypes} from 'react';
import Member             from './member.js'
import { connect }        from 'react-redux';
import Console            from '../console/index';

const Facilitator = React.createClass({
  render() {
    const { facilitator, openAvatarModal } = this.props;

    return (
      <div className='facilitator-section'>
        <div className='div-inline-block'>
          <div className='div-inline-block cursor-pointer' onClick={ openAvatarModal }>
            <Member key={ facilitator.id } member={ facilitator } />
          </div>

          <div className='say-section'>
            <div className='outerbox'>
              <div className='triangle'></div>
              <div className='innerbox'>
                <p className='text-break-all'>
                  Say something nice if you wish!
                </p>
              </div>
            </div>
          </div>

          <Console />
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    facilitator: state.members.facilitator
  }
};

export default connect(mapStateToProps)(Facilitator);
