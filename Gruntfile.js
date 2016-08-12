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
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');

  grunt.registerTask('default', ['jshint']);

};
