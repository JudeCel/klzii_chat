import React, {PropTypes}       from 'react';

const Input = ({ onKeyPress, handleChange, action, value }) => {
  return (
    <div className="form-group col-md-12">
      <div className="input-group">
        <div className="input-group-addon">{action}</div>
        <input
          onKeyPress={ onKeyPress }
          value={ value }
          type="text"
          onChange={ handleChange }
          className="form-control"
          placeholder="Message"
        />
      </div>
    </div>
  );
}
export default Input;
