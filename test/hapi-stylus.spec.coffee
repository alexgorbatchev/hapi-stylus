require 'coffee-errors'

chai = require 'chai'
Hapi = require 'hapi'

GLOBAL.expect = chai.expect
plugin = require '../src/hapi-stylus'
path = require 'path'

describe 'simple hapi-stylus usage', ->
  server = null

  before (done) ->
    server = new Hapi.Server
    server.connection()
    server.register
      register: plugin
      options: home: __dirname
      , done

  it 'renders a file', (done) ->
    server.inject '/styles/fixture.css', ({statusCode, result}) ->
      expect(statusCode).to.equal 200
      expect(result).to.equal '.text{color:#f00}'
      done()

  it 'returns 404 when not found', (done) ->
    server.inject '/styles/foo.css', ({statusCode, result}) ->
      expect(statusCode).to.equal 404
      done()

  it 'returns 500 when there is a syntax error', (done) ->
    server.inject '/styles/invalid.css', ({statusCode, result}) ->
      expect(statusCode).to.equal 500
      done()

  after (done) -> server.stop done

describe 'hapi-stylus configuration', ->
  server = null

  beforeEach (done) ->
    server = new Hapi.Server
      debug: log: ['error']
    server.connection()
    done()

  it 'makes compress optional', (done) ->
    server.register
      register: plugin
      options:
        home: __dirname
        compress: false
      , ->
          server.inject '/styles/fixture.css', ({statusCode, result}) ->
            expect(statusCode).to.equal 200
            expect(result).to.equal '.text {\n  color: #f00;\n}\n'
            server.stop
            done()

  it 'allows adding line numbers', (done) ->
    server.register
      register: plugin
      options:
        home: __dirname
        linenos: true
      , ->
          server.inject '/styles/fixture.css', ({statusCode, result}) ->
            expect(statusCode).to.equal 200
            expect(result).to.equal """
              
              /* line 3 : #{path.resolve(__dirname, 'fixture.styl')} */

              /* line 1 : #{path.resolve(__dirname, '../node_modules/stylus/lib/functions/index.styl')} */

              /* line 2 : #{path.resolve(__dirname, 'fixture.styl')} */
              .text{color:#f00}
              """
            done()

  it 'allows adding a prefix', (done) ->
    server.register
      register: plugin
      options:
        home: __dirname
        prefix: 'foo-'
      , ->
          server.inject '/styles/fixture.css', ({statusCode, result}) ->
            expect(statusCode).to.equal 200
            expect(result).to.equal '.foo-text{color:#f00}'
            done()

  it 'allows using plugins', (done) ->
    server.register
      register: plugin
      options:
        home: __dirname
        use: [
          require('nib')
        ]
      , ->
          server.inject '/styles/fixture.nib.css', ({statusCode, result}) ->
            expect(statusCode).to.equal 200
            expect(result).to.equal '.text{color:#f00;width:5px;height:5px}'
            done()

  afterEach (done) -> server.stop done