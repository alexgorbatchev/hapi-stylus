# hapi-stylus

[![NPM version](https://badge.fury.io/js/hapi-stylus.svg)](http://badge.fury.io/js/hapi-stylus)
[![Dependency status](https://david-dm.org/alexgorbatchev/hapi-stylus.svg)](https://david-dm.org/alexgorbatchev/hapi-stylus)
[![devDependency Status](https://david-dm.org/alexgorbatchev/hapi-stylus/dev-status.svg)](https://david-dm.org/alexgorbatchev/hapi-stylus#info=devDependencies)
[![Build Status](https://api.travis-ci.org/alexgorbatchev/hapi-stylus.svg?branch=master)](https://travis-ci.org/alexgorbatchev/hapi-stylus)
[![GitTip](http://img.shields.io/gittip/alexgorbatchev.svg)](https://www.gittip.com/alexgorbatchev/)

[![NPM](https://nodei.co/npm/hapi-stylus.svg)](https://npmjs.org/package/hapi-stylus)

A basic [Stylus] plugin for [hapi].

## Installation

    npm install hapi-stylus

## Running tests

    $ npm install
    $ npm test

## Usage Example

In a server:

    server.pack.register({
      plugin: require('hapi-stylus'),
      options: {
        home: __dirname + "/styles",
        route: "/styles/{filename*}" // default
      }
    }, done);

In a plugin:

    var register = function(plugin, options, next) {
      plugin.register({
        plugin: require('hapi-stylus'),
        options: {
          home: __dirname + "/styles",
          route: "/styles/{filename*}" // default
        }
      });
      next();
    };

## Options

### home

Path in which all styles files are located. Plugin will make all attempts to avoid path hacks and will server 404 for all files outside that folder.

### route

Defaults to `/styles/{filename*}`. All paths matching this route will be considered CSS files. `.css` extension gets replaced with `.styl`. Also, `filename` has to be present in the route.

## Notes

Please note that the plugin doesn't do any caching by itself.

# License

The MIT License (MIT)

Copyright (c) 2014 Alex Gorbatchev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[Stylus]: http://learnboost.github.io/stylus/
[hapi]: http://hapijs.com/
