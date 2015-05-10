stylus = require 'stylus'
fs     = require 'fs'
path   = require 'path'
Boom   = require 'boom'

register = (plugin, {route, home, compress, cache, ending, linenos, prefix, use}, next) ->
  handler = (request, reply) ->
    {filename} = request.params
    filename = path.normalize filename

    return reply(Boom.notFound()) if filename.charAt(0) is '.'

    stylusName = filename.replace /\.css$/, (if ending then ending else '.styl')
    pth = "#{home}/#{stylusName}"

    fs.readFile pth, 'utf8', (err, content) ->
      return reply err.code and Boom.notFound() or Boom.badImplementation(err) if err?

      style = stylus(content,
        filename : pth
        dest     : "#{home}/#{filename}"
        prefix   : prefix || ''
        compress : if compress? then compress else true
        cache    : if cache? then cache else true
        linenos  : if linenos? then linenos else false
      )

      if Array.isArray(use)
        for func in use when typeof func == 'function'
          style.use(func())

      style.render (err, css) ->
        return reply(Boom.badImplementation(err)) if err?
        reply(css).type('text/css')

  plugin.route [
    {method: 'GET', path: route or '/styles/{filename*}', handler}
  ]

  next()

register.attributes =
  multiple : yes
  pkg      : require '../package.json'

module.exports = {register}
