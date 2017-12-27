import React, {PropTypes} from 'react';

const DownloadPrizeDrawReport = React.createClass({
  render() {
    const { report } = this.props;

    return (
      <div className='download-section'>
        <div className='col-md-12 text-center dialog-text-mod'>
          <h3><b>Please Note!</b></h3>
          <p><h4>This CSV is to be used for the purposes of a Prize Draw only. It may contain details of Guests who do not want to be contacted again. Except to be notified about the Prize Draw.</h4></p>
          <p><i>FYI, those to Invite Again are in a New Contact List.</i></p>
        </div>

        <div className='col-md-12 text-center'>
          <a href={ report.resource.url.full } target='_blank' download>
            <i className='fa fa-download' />
            <br />
            Download
          </a>
        </div>
      </div>
    )
  }
});

export default DownloadPrizeDrawReport;
