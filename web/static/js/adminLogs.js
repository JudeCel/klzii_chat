import "babel-polyfill";
import { Provider }             from 'react-redux';
import React                    from 'react';
import ReactDOM                 from 'react-dom';
import Logs                     from './admin/logs';
import configureStore           from './admin/store';

const store  = configureStore();
const target = document.getElementById('logs_container');
const node = (
  <Provider store={store}>
    <div>
      <Logs />
    </div>
  </Provider>
)

ReactDOM.render(node, target);
