import React, {PropTypes} from 'react';
import SelectReport       from './pages/index';
import DownloadReport     from './pages/download';
import FailedReport       from './pages/failed';
import SelectCustom       from './pages/custom';
import AccessDenied       from './pages/accessDenied';
import DownloadPrizeDrawReport from './pages/downloadPrizeDraw';

const ReportsPages = React.createClass({
  render() {
    const { rendering, changePage, report, mapStruct, reference } = this.props;

    switch (rendering) {
      case 'index':
        return <SelectReport changePage={ changePage } report={ report } mapStruct={ mapStruct } />
      case 'download':
        return <DownloadReport changePage={ changePage } report={ report } />
      case 'failed':
        return <FailedReport changePage={ changePage } report={ report } />
      case 'selectCustom':
        return <SelectCustom changePage={ changePage } report={ report } mapStruct={ mapStruct } reference={ reference } />
      case 'accessDenied':
        return <AccessDenied changePage={ changePage } />
      case 'download_prize_draw':
        return <DownloadPrizeDrawReport changePage={ changePage } report={ report } />
    }
  }
});

export default ReportsPages;
