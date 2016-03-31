import React, {PropTypes}   from 'react';
import Member               from './member.js'
import { connect }          from 'react-redux';
import Console              from '../console/index';

const Facilitator = React.createClass({
  render() {
    const { facilitator, colours } = this.props;
    return (
      <div className='facilitator-section'>
        <div className='div-inline-block'>
          <div className='div-inline-block'>
            <Member key={ facilitator.id } member={ facilitator } colour={ colours.facilitator } />
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

          <Console/>
        </div>
      </div>
    )
  }
});

const mapStateToProps = (state) => {
  return {
    facilitator: state.members.facilitator,
    colours: state.chat.session.colours
  }
};

export default connect(mapStateToProps)(Facilitator);
