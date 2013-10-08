module.exports = (grunt)->
  grunt.initConfig
    pkg: "<json:package.json>"
    coffee:
      app:
        files: 
          "index.js": "index.coffee"
        options:
          bare: true
      lib:
        files:
          "lib/maze.js": "lib/maze.coffee"
          "lib/agent.js": "lib/agent.coffee"
        options:
          bare: true

  grunt.loadNpmTasks "grunt-contrib-coffee"
