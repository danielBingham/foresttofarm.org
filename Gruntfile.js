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
    jasmine: {
        all: {
            src: 'public/scripts/app/**/*.js',
            options: {
                specs: 'spec/javascript/**/*Spec.js',
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
  grunt.loadNpmTasks('grunt-contrib-jasmine');

  grunt.registerTask('default', ['jshint', 'jasmine']);

};
