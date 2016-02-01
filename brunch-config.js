exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      // joinTo: "js/app.js",

      // To use a separate vendor.js bundle, specify two files path
      // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
      joinTo: {
       "js/app.js": /(web\/static\/js)/,
       "js/vendor.js": /(web\/static\/vendor\/js)|(browser.js)|(phoenix_html)|(phoenix)/
      },
      //
      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      order: {
        before: [
          "web/static/vendor/js/jquery-2.2.0.js"
        ],
        after: [
          "web/static/vendor/js/angular.mini.js",
          "web/static/vendor/js/bootstrap.min.js",
          "web/static/vendor/js/handlebars-v4.0.5.js",
        ]
      }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": /(web\/static\/css)/,
        "css/vendor.css": /(web\/static\/vendor\/css)|(deps)/
       },
      order: {
        before: [
          "web/static/vendor/css/bootstrap.min.css"
        ],
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },
  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    // Whitelist the npm deps to be pulled in as front-end assets.
    // All other deps in package.json will be excluded from the bundle.
    whitelist: ["phoenix", "phoenix_html"]
  }
};
