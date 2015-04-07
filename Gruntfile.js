module.exports = function(grunt) {

    grunt.initConfig({
        nodewebkit: {
            options: {
                version: '0.12.0',
                buildDir: './build',
                macIcns: './app/beaglebone-getting-started.app/Contents/Resources/nw.icns',
                platforms: ['win', 'osx', 'linux'] // builds both 32 and 64 bit versions
            },
            src: ['./app/**', './Docs/**', './README.htm']
        }
    });

    grunt.loadNpmTasks('grunt-node-webkit-builder');
    grunt.registerTask('default', ['nodewebkit']);

};
