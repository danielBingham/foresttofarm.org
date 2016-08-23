module.exports = function(grunt) {

  grunt.initConfig({
    jshint: {
      files: [
          'Gruntfile.js', 
          'public/scripts/app/**/*.js'],
      options: {
        globals: {
          jQuery: true
        }
      }
    },
    'phpunit-runner': {
        all: {
            options: {
                phpunit: 'phpunit'
            },
            files: {
                testFiles: 'app/tests/'
            }
        }
    },
    jasmine: {
        all: {
            src: 'public/scripts/app/**/*.js',
            options: {
                specs: 'tests/**/*Spec.js',
                template: require('grunt-template-jasmine-requirejs'),
                templateOptions: {
                    requireConfigFile: 'public/scripts/bootstrap.js',
                    requireConfig: {
                        baseUrl: 'public/scripts',
                    }
                }

            }
        }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-phpunit-runner');
  grunt.loadNpmTasks('grunt-contrib-jasmine');

  grunt.registerTask('default', ['jshint', 'phpunit-runner', 'jasmine']);

};
