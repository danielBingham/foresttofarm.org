module.exports = function(grunt) {

  grunt.initConfig({
    jshint: {
      files: [
          'Gruntfile.js', 
          'public/scripts/**/*.js',
          '!public/scripts/library/**'],
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
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-phpunit-runner');

  grunt.registerTask('default', ['jshint', 'phpunit-runner']);

};
