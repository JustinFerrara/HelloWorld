CSON = require 'cson'
path = require 'path'

module.exports = (grunt) ->

  # Files to monitor.
  styleFiles = [
    'public/**/*.sass'
  ]
  serverScripts = [
    'server.coffee',
    'Gruntfile.coffee',
    'app/**/*.coffee',
    'config/**/*.coffee',
    'test/**/*.coffee',
  ]
  clientScripts = [
    'components/**/*.coffee',
    'public/**/*.coffee'
  ]
  scriptFiles = serverScripts.concat clientScripts

  # Grunt Config
  grunt.initConfig
    watch:
      serverScripts:
        files: serverScripts,
        tasks: ['coffeelint', 'express:dev']
        options:
          spawn: false
      clientScripts:
        files: clientScripts
        tasks: ['build-fe-js-dev']
        options:
          livereload: 35629
      styles:
        files: styleFiles
        tasks: ['sass']
        options:
          livereload: 35629

    express:
      options:
        script: 'index.js'
      dev:
        options:
          node_env: 'development'
      test:
        options:
          node_env: 'test'

    sass:
      options:
        sourceMap: true
        style: 'compressed'
      dist:
        files:
          './public/css/style.css': './public/sass/main.sass'

    coffeelint:
      all: scriptFiles
      options: CSON.requireCSONFile './coffeelint.cson'

    webpack:
      dist:
        stats:
          colors: true
        storeStatsTo: 'webpackStats'
        devtool: 'source-map'
        cache: true
        entry:
          main: './public/coffee/main.coffee'
        output:
          path: './public/js/'
          publicPath: '/js/'
          filename: '[name].js'
        resolve:
          alias:
            components: path.resolve './components'
            public: path.resolve './public'
          extensions: ['', '.coffee', '.js']
          modulesDirectories: ['public', 'node_modules']
        module:
          noParse: [/moment.js/]
          loaders: [
            {test: /\.coffee$/, loader: 'coffee'}
            {test: /\.json$/, loader: 'json'}
            {
              test: /\.hbs/,
              loader: 'handlebars-loader'
              query:
                exclude: 'node_modules'
                helperDirs: [
                  path.join __dirname, 'components', 'utils', 'helpers', 'handlebars-helpers/'
                  path.join __dirname, 'components/'
                ]
                partialDirs: [
                  path.join __dirname, 'app', 'views', 'partials/'
                ]
            }
          ]

        node:
          fs: 'empty'

  # Npm Tasks
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-webpack'
  grunt.loadNpmTasks 'grunt-sass'

  # Tasks
  grunt.registerTask('dev', ['sass', 'build-fe-js-dev', 'express:dev', 'watch'])
  grunt.registerTask('test', ['coffeelint', 'mochaTest', 'express:dev'])

  # Helper Tasks
  grunt.registerTask('build-fe-js-dev', ['coffeelint', 'webpack'])
