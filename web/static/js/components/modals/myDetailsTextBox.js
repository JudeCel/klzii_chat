import React       from 'react';
import { connect } from 'react-redux';
import { Modal }   from 'react-bootstrap';
import mixins      from '../../mixins';

const MyDetailsTextBox = React.createClass({
  render() {
    const { label, placeholder, inputId, onBlur } = this.props;
    return (
      <div className="form-group">
        <label className="control-label col-md-4 text-no-bold" htmlFor={ inputId }>{ label }</label>
        <div className="col-md-8">
          <input type="text" className="form-control" id={ inputId } placeholder={ placeholder } onBlur={ onBlur } />
        </div>
      </div>
    );
  }
});

const mapStateToProps = (state) => {
  return {
    modalWindows: state.modalWindows,
    observers: state.members.observers,
    colours: state.chat.session.colours,
    currentUser: state.members.currentUser,
  }
};

export default connect(mapStateToProps)(MyDetailsTextBox);
