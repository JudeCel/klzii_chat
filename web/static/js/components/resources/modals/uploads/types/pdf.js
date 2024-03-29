import React, {PropTypes}  from 'react';

const UploadTypePdf = React.createClass({
  render() {
    const { url } = this.props;

    return (
      <div className='text-center'>
        <a href={ url.full } target='_blank'><i className='icon-pdf' /></a>
      </div>
    )
  }
});

export default UploadTypePdf;
