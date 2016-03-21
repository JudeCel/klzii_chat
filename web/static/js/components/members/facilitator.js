import React, {PropTypes}   from 'react';
import Member               from './member.js'
import { connect }          from 'react-redux';

const Facilitator = React.createClass({
  render() {
    const { facilitator } = this.props;
    return (
      <div className="row facilitator-section col-md-2">
        <Member
          key={ facilitator.id }
          member={ facilitator }
        />
      </div>
    );
  }
})
const mapStateToProps = (state) => {
  return {
    facilitator: state.members.facilitator,
  }
};
export default connect(mapStateToProps)(Facilitator);
