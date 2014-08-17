'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var yosay = require('yosay');
var chalk = require('chalk');


var StaticSiteGenerator = yeoman.generators.Base.extend({
  init: function () {
    this.pkg = require('../package.json');

    this.on('end', function () {
      if (!this.options['skip-install']) {
        this.installDependencies();
      }
    });
  },

  app: function () {
    [
      'public',
      'public/vendor',
      'public/css',
      'public/css/vendor',
      'public/js',
      'public/js/vendor',
      'public/img',
    ].forEach(function(p) { this.mkdir(p); }, this);

    [
      ['_Gruntfile.coffee', 'Gruntfile.coffee'],
      ['_package.json', 'package.json'],
      ['_bower.json', 'bower.json'],
      ['_.gitignore', '.gitignore'],
    ].forEach(function(p) { this.copy(p[0], p[1]); }, this);
  },

  projectfiles: function () {
  }
});

module.exports = StaticSiteGenerator;
