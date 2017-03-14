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
    new ExtractTextPlugin({
      filename: 'css/[name].css',
      disable: false,
      allChunks: true
    }),
    new webpack.NoEmitOnErrorsPlugin(),
    new CopyWebpackPlugin([{ from: 'web/static/assets/images', to: "images" }]),
    new CopyWebpackPlugin([{ from: 'web/static/assets/sounds', to: "sounds" }]),
    new CopyWebpackPlugin([{ from: 'web/static/css/reporting', to: "css/reporting" }]),
    new CopyWebpackPlugin([{ from: 'web/static/js/reporting', to: "js/reporting" }]),
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
    admin: [
      web('css/admin.sass'),
      web('js/admin.js'),
    ],
    'adminLogs': [
      web('js/adminLogs.js')
    ],
    'updatePackages': [
      web('js/updatePackages.js')
    ],
  },

  // where webpack should output our files
  output: {
    path: join('priv/static'),
    filename: 'js/[name].js',
  },

  resolve: {
    modules: ['node_modules', 'web/static']
  },

  // more information on how our modules are structured, and
  //
  // in this case, we'll define our loaders for JavaScript and CSS.
  // we use regexes to tell Webpack what files require special treatment, and
  // what patterns to exclude.
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
      {
        test: /\.sass$/,
        loader: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: ["css-loader","sass-loader"],
        }),
      },
      {
        test: /\.(json|ttf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
        use:[ "url-loader" ]
      }
    ],
  },

  // what plugins we'll be using - in this case, just our ExtractTextPlugin.
  // we'll also tell the plugin where the final CSS file should be generated
  // (relative to config.output.path)
  plugins: plugins(),
};

// if running webpack in production mode, minify files with uglifyjs
