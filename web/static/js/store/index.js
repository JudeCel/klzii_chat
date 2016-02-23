import { createStore, applyMiddleware, compose }  from 'redux';
import createLogger                               from 'redux-logger';
import thunkMiddleware                            from 'redux-thunk';
import reducers                                   from '../reducers';
import DevTools from '../containers/DevTools';


const loggerMiddleware = createLogger({
  level: 'info',
  collapsed: true,
});


const enhancer = compose(
  // Middleware you want to use in development:
  applyMiddleware(thunkMiddleware, loggerMiddleware),
  // Required! Enable Redux DevTools with the monitors you chose
  DevTools.instrument()
);

export default function configureStore() {
  const store = createStore(reducers, {}, enhancer);

  return store;
}
