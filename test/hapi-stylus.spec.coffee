require 'coffee-errors'

chai = require 'chai'
Hapi = require 'hapi'

GLOBAL.expect = chai.expect
plugin = require '../src/hapi-stylus'

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
            expect(result).to.equal '\n/* line 3 : /Users/martin/Private/projects/hapi-stylus/test/fixture.styl */\n\n/* line 1 : /Users/martin/Private/projects/hapi-stylus/node_modules/stylus/lib/functions/index.styl */\n\n/* line 2 : /Users/martin/Private/projects/hapi-stylus/test/fixture.styl */\n.text{color:#f00}'
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

  afterEach (done) -> server.stop done