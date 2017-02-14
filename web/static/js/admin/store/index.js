import { createStore, applyMiddleware, compose }  from 'redux';
import createLogger                               from 'redux-logger';
import thunkMiddleware                            from 'redux-thunk';
import reducers                                   from '../reducers';

const loggerMiddleware = createLogger({
  level: 'info',
  collapsed: true,
});


const enhancer = compose(
  applyMiddleware(thunkMiddleware, loggerMiddleware),
);

export default function configureStore() {
  const store = createStore(reducers, {}, enhancer);

  return store;
}
