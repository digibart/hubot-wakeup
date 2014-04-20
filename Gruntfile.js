'use strict';

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    bump: {
      options: {
        commit: true,
        commitMessage: 'Release v%VERSION%',
        tagMessage: 'Version %VERSION%',
        push: false
      }
    },
    watch: {
      files: ['Gruntfile.js', 'test/**/*.coffee', 'src/**/*.coffee'],
      tasks: ['test']
    },
    jasmine_node: {
        options: {
          forceExit: true,
          match: '.',
          matchall: false,
          extensions: 'coffee',
          specNameMatcher: 'spec',
          coffee: true,
        },
        all: ['test/']
      }
  });

  grunt.event.on('watch', function(action, filepath, target) {
    grunt.log.writeln(target + ': ' + filepath + ' has ' + action);
  });

  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  grunt.registerTask('test', ['jasmine_node']);
  grunt.registerTask('test:watch', ['watch']);
  grunt.registerTask('default', ['test']);
};
