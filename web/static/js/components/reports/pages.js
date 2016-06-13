import React, {PropTypes} from 'react';
import SelectReport       from './pages/index';
import DownloadReport     from './pages/download';
import FailedReport       from './pages/failed';

const ReportsPages = React.createClass({
  render() {
    const { rendering, changePage, report } = this.props;

    switch (rendering) {
      case 'index':
        return <SelectReport changePage={ changePage } />
      case 'download':
        return <DownloadReport report={ report } />
      case 'failed':
        return <FailedReport report={ report } />
    }
  }
});

export default ReportsPages;
