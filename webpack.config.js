'use strict';

var path = require('path');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var webpack = require('webpack');

// helpers for writing path names
// e.g. join("web/static") => "/full/disk/path/to/hello/web/static"
function join(dest) { return path.resolve(__dirname, dest); }

function web(dest) { return join('web/static/' + dest); }
function plugins() {
  var productionList = [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': '"production"'
    }),
    new webpack.optimize.UglifyJsPlugin({ minimize: true })
  ]

  var defaultList = [
    new ExtractTextPlugin('css/app.css'),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.NoErrorsPlugin(),
    new CopyWebpackPlugin([{ from: 'web/static/assets/images', to: "images" }]),
    new CopyWebpackPlugin([{ from: 'web/static/assets/sounds', to: "sounds" }]),
    new CopyWebpackPlugin([{ from: 'web/static/css/reporting', to: "css/reporting" }]),
    new CopyWebpackPlugin([{ from: 'web/static/js/reporting', to: "js/reporting" }]),
    new webpack.optimize.DedupePlugin()
  ]

  switch (process.env.NODE_ENV) {
    case "production":
      return defaultList.concat(productionList)
    default:
      return defaultList
  }
}

var config = module.exports = {
  // our app's entry points - for this example we'll use a single each for
  // css and js
  devtool: process.env.NODE_ENV === 'production' ? 'source-map' : 'eval',
  entry: {
    app: [
      web('css/app.sass'),
      web('js/app.js'),
    ],
  },

  // where webpack should output our files
  output: {
    path: join('priv/static'),
    filename: 'js/app.js',
  },

  resolve: {
    extensions: ['', '.js', '.sass', '.scss'],
    modulesDirectories: ['node_modules'],
  },

  resolveLoader: {
    root: path.join(__dirname, 'node_modules')
  },

  // more information on how our modules are structured, and
  //
  // in this case, we'll define our loaders for JavaScript and CSS.
  // we use regexes to tell Webpack what files require special treatment, and
  // what patterns to exclude.
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          cacheDirectory: true,
          plugins: ['transform-decorators-legacy']
        },
      },
      {
        test: /\.sass$/,
        loader: ExtractTextPlugin.extract('style', 'css!sass?indentedSyntax&includePaths[]=' + __dirname +  '/node_modules'),
      },
      {
        test: require.resolve('snapsvg'),
        loader: 'imports-loader?this=>window,fix=>module.exports=0'
      },
      {
        test: /\.(ttf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
        loader: 'url-loader?limit=8192'
      }
    ],
  },

  // what plugins we'll be using - in this case, just our ExtractTextPlugin.
  // we'll also tell the plugin where the final CSS file should be generated
  // (relative to config.output.path)
  plugins: plugins(),
};

// if running webpack in production mode, minify files with uglifyjs
