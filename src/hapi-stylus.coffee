stylus = require 'stylus'
fs = require 'fs'
path = require 'path'
Boom = require 'boom'

register = (plugin, {route, home, compress, cache, ending, linenos, prefix}, next) ->
  handler = (request, reply) ->
    {filename} = request.params
    filename = path.normalize filename

    if filename.charAt(0) is '.'
      return reply(Boom.notFound())

    stylusName = filename.replace /\.css$/, (if ending then ending else '.styl')
    pth = "#{home}/#{stylusName}"

    fs.readFile pth, 'utf8', (err, content) ->
      if err?
        return reply(
          if err.code then Boom.notFound() else Boom.badImplementation(err) 
        )

      style = stylus(content, 
          filename: pth
          dest: "#{home}/#{filename}"
          prefix: prefix || ''
          compress: if compress? then compress else true 
          cache: if cache? then cache else true 
          linenos: if linenos? then linenos else false
        )
      style.render (err, css) ->
          if err?
            return reply(Boom.badImplementation(err))

          reply(css)
            .type('text/css')

  plugin.route [
    {method: 'GET', path: route or '/styles/{filename*}', handler}
  ]

  next()

register.attributes =
  multiple: yes
  pkg: require '../package.json'

module.exports = {register}
