path = require 'path'
ncp = require 'ncp'
Q = require 'q'

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    watch:
      livereload:
        files: [
          '**/*'
        ]
        tasks: [
        ]
        options:
          cwd: 'public'
          livereload: true


    harp:
      server:
        server: true
        source: 'public'
      build:
        source: 'public'
        dest: 'www'

    concurrent:
      dev: [
        'harp:server'
        'watch'
      ]
      options:
        logConcurrentOutput: true


    components:
      'public/js/vendor': [
        'bower_components/jquery/dist/jquery.js'
        'bower_components/jquery/dist/jquery.min.js'
        'bower_components/jquery/dist/jquery.min.map'
        'bower_components/lodash/dist/lodash.js'
        'bower_components/lodash/dist/lodash.min.js'
        'bower_components/holderjs/holder.js'
      ]
      'public/css/vendor': [
      ]
      'public/img': [
      ]
      'public/vendor': [
        'bootstrap': 'bower_components/bootstrap/dist'
        'font-awesome': 'bower_components/font-awesome'
      ]



  grunt.registerTask 'copy-components', ->
    done = @async()
    jobs = Q.all(for dest, sources of grunt.config.get('components')
      grunt.file.mkdir(dest)
      Q.all(for source in sources
        if typeof source == 'string'
          basename = path.basename(source)
        else
          basename = Object.keys(source)[0]
          source = source[basename]
        grunt.log.writeln("copying #{basename}")
        Q.nfcall ncp, source, "#{dest}/#{basename}"
      )
    )
    jobs.then -> done()


  grunt.registerTask(name, targets) for name, targets of {
    'initialize': [
      'copy-components'
    ]
    'build': [
      'initialize'
      'harp:build'
    ]
    'server': ['harp:server']
    'default': [
      'concurrent:dev'
    ]
  }
