module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    # Define path
    config: {
      app: 'app'
      dist: 'dist'
      test: 'test'
      build: 'build'
    }
    # Watch
    watch: {
      coffee: {
        files: ['<%= config.app %>/coffee/{,*/}*.coffee']
        tasks: ['coffee:dev']
      }
      testUnit: {
        files: ['<%= config.test %>/coffee/unit/{,*/}*.coffee']
        tasks: ['coffee:test']
      }
      testE2E: {
        files: ['<%= config.test %>/coffee/e2e/{,*/}*.coffee']
        tasks: ['coffee:e2e']
      }
      compass: {
        files: ['<%= config.app %>/sass/{,*/}*.sass']
        tasks: ['sass:dev']
      }
      jadeIndex: {
        files: ['<%= config.app %>/index.jade']
        tasks: ['jade:index']
      }
      jade: {
        files: ['<%= config.app %>/view/{,*/}*.jade']
        tasks: ['jade:view']
      }
    }
    # -------------------------- Dev -----------------------------
    # CoffeeScript
    coffee: {
      options:
        bare: true
      dev: {
        options:
          join: true
        files:
          '<%= config.app %>/scripts/main.js': [
            '<%= config.app %>/coffee/main.coffee'
            '<%= config.app %>/coffee/{.*/}*.coffee'
            '<%= config.app %>/coffee/controller/*.coffee'
          ]
      }
      test: {
        expand: true
        flatten: true
        cwd: 'test/coffee/unit'
        src: ['*.coffee']
        dest: 'test/spec/'
        ext: '.js'
      }
      e2e: {
        expand: true
        flatten: true
        cwd: 'test/coffee/e2e'
        src: ['*.coffee']
        dest: 'test/e2e/'
        ext: '.js'
      }
    }
    # Compass
    compass: {
      dev: {
        options:
          basePath:        '<%= config.app %>/'
          sassDir:         'sass/'
          cssDir:          'styles/'
          imagesDir:       'img/'
          javascriptsDir:  'scripts/'
          fontsDir:        'fonts/'
          relativeAssets:  true
          outputStyle:     'expanded'
      }
    }
    # Jade
    jade: {
      options:
        client: false
        compileDebug: true
      index: {
        src: '<%= config.app %>/index.jade'
        dest: '<%= config.app %>/'
      }
      view: {
        src: ['<%= config.app %>/views/{.*/}*.jade']
        dest: '<%= config.app %>/views/'
      }
    }
    # -------------------------- Dist ----------------------------
    # We copy all the directory
    copy: {
      dist: {
        expand: true
        filter: 'isFile'
        cwd: '<%= config.app %>/'
        src: '**'
        dest: '<%= config.dist %>'
      }
    }
    # Prepare AngularJs app for minify
    ngmin: {
      dist: {
        src: ['<%= config.dist %>/scripts/main.js']
        dest: '<%= config.dist %>/scripts/main.js'
      }
    }
    # Uglify JS
    uglify: {
      options:
        mangle: true
        preserveComments: false
        beautify: false
      dist: {
        files:
          '<%= config.dist %>/scripts/main.js': '<%= config.dist %>/scripts/main.js'
      }
    }
    # Minify the css
    cssmin: {
      dist: {
        files:
          '<%= config.dist %>/styles/style.css': '<%= config.dist %>/styles/style.css'
      }
    }
    # Delete useless files
    clean: {
      options:
        force: true
      before: {
        src: [
          '<%= config.dist %>/sass/'
          '<%= config.dist %>/coffee/'
          '<%= config.dist %>/index.jade'
          '<%= config.dist %>/view/{,*/}*.jade'
        ]
      }
      after: {
        src: [
          '<%= config.dist %>/'
        ]
      }
    }
    # Build the node-webkit application
    nodewebkit: {
      options:
        build_dir: '<%= config.build %>/'
        keep_nw: true
        mac: true
        win: true
        linux32: true
        linux64: true
      dist: ['<%= config.dist %>/**/*']
    }
  # -------------------------- Test ----------------------------
    concurrent: {
      dev: {
        tasks: ['karma:unit', 'karma:e2e', 'watch']
        options:
          logConcurrentOutput: true
      }
    }
    karma: {
      unit: {
        configFile: 'karma.conf.js'
      }
      e2e: {
        configFile: 'karma-e2e.conf.js'
      }
    }
  }

  grunt.registerTask('build', [
    'coffee:dev'
    'compass'
    'jade'
    'copy'
    'ngmin'
    'uglify'
    'cssmin'
    'clean:before'
    'nodewebkit'
    'clean:after'
  ])

  grunt.registerTask('default', [
    'concurrent:dev'
  ])
