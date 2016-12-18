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

    uglify:
      dist:
        options:
          compress:
            drop_console: true
          report: 'min'
        files: [
          expand: true,
          cwd: './public/swimsuit/js'
          src: ['*.js']
          dest: './public/swimsuit/js'
        ]

    cssmin:
      dist:
        files: [
          expand: true,
          cwd: './public/swimsuit/css'
          src: ['*.css', '!*.min.css']
          dest: './public/swimsuit/css'
          ext: '.min.css'
        ]

    mochaTest:
      all:
        options:
          timeout: 9000
          reporter: 'spec'
          require: 'coffee-script/register'
          clearRequireCache: true
        src: ['test/mocha/**/*.coffee']

    sass:
      options:
        sourceMap: true
        style: 'compressed'
      dist:
        files:
          './public/swimsuit/css/style.css': './public/sass/main.sass'

    assemble:
      options:
        layout: 'docs/templates/template.hbs'
        helpers: 'docs/helpers/helpers.coffee'
        assets: 'docs/assets'
        data: 'docs/data/*.json'
      base:
        files: [
          cwd: './docs/'
          dest: './public/styleguide'
          expand: true
          src: ['**/*.md']
        ]

    parker:
      options:
        metrics: [
          'TotalStylesheets'
          'TotalStylesheetSize'
          'TotalRules'
          'TotalSelectors'
          'TotalIdentifiers'
          'TotalDeclarations'
          'SelectorsPerRule'
          'IdentifiersPerSelector'
          'SpecificityPerSelector'
          'TopSelectorSpecificity'
          'TopSelectorSpecificitySelector',
          'TotalIdSelectors'
          'TotalUniqueColours'
          'TotalImportantKeywords'
          'TotalMediaQueries'
        ]
        file: './docs/style-report.md'
        usePackage: true
      src: [ './public/swimsuit/css/*.css' ]

    casperjs:
      options: {}
      files: ['test/casper/**/*.coffee']

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
          path: './public/swimsuit/js/'
          publicPath: '/swimsuit/js/'
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
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-webpack'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-casperjs'
  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-parker'
  grunt.loadNpmTasks 'grunt-assemble'

  # Tasks
  grunt.registerTask('build-styleguide', ['sass', 'cssmin', 'parker', 'assemble'])
  grunt.registerTask('dev', ['sass', 'build-fe-js-dev', 'express:dev', 'watch'])
  grunt.registerTask('test', ['coffeelint', 'mochaTest', 'express:dev'])

  # Helper Tasks
  grunt.registerTask('build-fe-prod', ['sass', 'webpack', 'uglify', 'cssmin'])
  grunt.registerTask('build-fe-js-dev', ['coffeelint', 'webpack'])
