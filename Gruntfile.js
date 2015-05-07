module.exports = function(grunt) {

    grunt.initConfig({
        nodewebkit: {
            options: {
                version: '0.12.0',
                buildDir: './build',
                macIcns: './App/beaglebone-getting-started.icns',
                platforms: ['win', 'osx', 'linux'] // builds both 32 and 64 bit versions
            },
            src: ['./App/**', './Docs/**', './README.htm']
        }
    });

    grunt.loadNpmTasks('grunt-node-webkit-builder');
    grunt.registerTask('default', ['nodewebkit']);

};
