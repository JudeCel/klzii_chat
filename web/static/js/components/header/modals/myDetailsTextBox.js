import React        from 'react';
import { connect }  from 'react-redux';
import { Modal }    from 'react-bootstrap';
import Formsy       from 'formsy-react';

const MyDetailsTextBox = React.createClass({
  mixins: [Formsy.Mixin],
  changeValue(event) {
    this.setValue(event.currentTarget.value);
  },
  render() {
    const { label, placeholder, inputId, onBlur, type } = this.props;
    const className = this.showRequired() ? ' required' : this.showError() ? ' error' : null;
    const errorMessage = this.getErrorMessage();
    
    return (
      <div className="form-group">
        <label className="control-label col-md-4 text-no-bold" htmlFor={ inputId }>{ label }</label>
        <div className={ className }>
          <input type={ type } className="form-control" id={ inputId } placeholder={ placeholder } onBlur={ onBlur }  onChange={ this.changeValue } value={ this.getValue() }/>
        </div>
        <span className="error-message">{ errorMessage }</span>
      </div>
    );
  }
});

const mapStateToProps = (state) => {
  return {
    colours: state.chat.session.colours,
  }
};

export default connect(mapStateToProps)(MyDetailsTextBox);
