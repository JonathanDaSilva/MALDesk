module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig {
    # Define path
    config: {
      app: 'app'
      dist: 'dist'
      test: 'test'
      e2e: 'e2e'
      build: 'build'
    }
    # Watch
    watch: {
      livereload: {
        files: [
          '<%= config.app %>/styles/*.css'
          '<%= config.app %>/scripts/*.js'
          '<%= config.app %>/views/*.html'
          '<%= config.app %>/index.html'
        ]
        options:
          livereload: 35729
      }
      coffee: {
        files: ['<%= config.app %>/coffee/{,*/}*.coffee']
        tasks: ['coffee:dev']
      }
      test: {
        files: ['<%= config.test %>/coffee/{,*/}*.coffee']
        tasks: ['coffee:test']
      }
      e2e: {
        files: ['<%= config.e2e %>/coffee/{,*/}*.coffee']
        tasks: ['coffee:e2e']
      }
      compass: {
        files: ['<%= config.app %>/sass/{,*/}*.sass']
        tasks: ['compass:dev']
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
    # Server
    connect: {
      dev: {
        options:
          port: 8000
          base: 'app'
          keepAlive: false
          livereload: 35729
      }
    }
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
            '<%= config.app %>/coffee/**/*.coffee'
            '<%= config.app %>/coffee/controller/*.coffee'
          ]
      }
      test: {
        expand: true
        flatten: true
        cwd: '<%= config.test %>/coffee/'
        src: ['*.coffee']
        dest: '<%= config.test %>/spec/'
        ext: '.js'
      }
      e2e: {
        expand: true
        flatten: true
        cwd: '<%= config.e2e %>/coffee/'
        src: ['*.coffee']
        dest: '<%= config.e2e %>/spec/'
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
    karma: {
      unit: {
        configFile: 'karma.conf.js'
      }
    }
  }

  grunt.registerTask('test', [
    'karma'
  ])
  grunt.registerTask('default', [
    'connect'
    'watch'
  ])
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
