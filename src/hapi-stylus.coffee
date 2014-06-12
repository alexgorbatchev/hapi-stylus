stylus = require 'stylus'
fs = require 'fs'
path = require 'path'

register = (plugin, {route, home}, next) ->
  handler = (request, reply) ->
    {filename} = request.params
    filename = path.normalize filename

    return reply().code(404) if filename.charAt(0) is '.'

    filename = filename.replace /\.css$/, '.styl'

    fs.readFile "#{home}/#{filename}", 'utf8', (err, content) ->
      return reply().code(404) if err?.code is 'ENOENT'
      return reply(plugin.hapi.error.internal err.stack) if err?

      stylus(content)
        .set('filename', filename)
        .set('compress', true)
        .render (err, css) ->
          return reply(plugin.hapi.error.internal err.message) if err?
          reply(css).type('text/css')

  plugin.route [
    {method: 'GET', path: route or '/styles/{filename*}', handler}
  ]

  next()

register.attributes = pkg: require '../package.json'
module.exports = {register}
