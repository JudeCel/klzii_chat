import { Provider }             from 'react-redux';
import React                    from 'react';
import ReactDOM                 from 'react-dom';
import configureStore           from './store';
import Chat                     from "./views/chat.js"

const store  = configureStore();
const target = document.getElementById('main_container');

const node = (
  <Provider store={store}>
    <div>
      <Chat/>
    </div>
  </Provider>
)

ReactDOM.render(node, target);
