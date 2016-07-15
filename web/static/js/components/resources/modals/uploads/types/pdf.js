import React, {PropTypes}  from 'react';

const UploadTypePdf = React.createClass({
  render() {
    const { url } = this.props;

    return (
      <a href={ url.full } target='_blank'><i className='icon-pdf' /></a>
    )
  }
});

export default UploadTypePdf;
