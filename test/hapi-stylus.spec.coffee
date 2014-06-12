require 'coffee-errors'

chai = require 'chai'
Hapi = require 'hapi'

GLOBAL.expect = chai.expect
plugin = require '../src/hapi-stylus'

describe 'hapi-stylus', ->
  server = null

  before (done) ->
    server = new Hapi.Server()

    server.pack.register
      plugin: require '../src/hapi-stylus'
      options: home: __dirname
      , done

  it 'renders a file', (done) ->
    server.inject '/styles/fixture.css', ({statusCode, result}) ->
      expect(statusCode).to.equal 200
      expect(result).to.equal 'body{color:#f00}'
      done()

  it 'returns 404 when not found', (done) ->
    server.inject '/styles/foo.css', ({statusCode, result}) ->
      expect(statusCode).to.equal 404
      done()

  it 'returns 500 when there is a syntax error', (done) ->
    server.inject '/styles/invalid.css', ({statusCode, result}) ->
      expect(statusCode).to.equal 500
      done()
