# helpers.coffee
# Set default helpers for handlebars templates.
_ = require 'lodash'

module.exports = (app) ->

  helpers =
    # Returns whether the current environment is development
    isDev: ->
      return app.get('env') isnt 'production'

    # Renders block if application is in production mode
    prodOnly: (context) ->
      if app.get('env') is 'production'
        return context.fn this

    # Given an image object and a crop name, return the full url
    # of the crop, if it exists, or if not, return the full image.
    renderCrop: (context, crop) ->
      image = context.image
      if context.crops[crop]?
        image = context.crops[crop]

      return image

    # Replace an item in a given string.
    replaceStr: (haystack, needle, replacement) ->
      if haystack and needle
        return haystack.replace(needle, replacement)
      else
        return ''

    # For use with dynamic partial calls.
    # This appends prefix to the partial name so that
    # handlebars will search in the specified directory
    getPartialFrom: (prefix, context) ->
      return "#{prefix}/#{context}"

    # Fetches a component partial from a component's render data
    getComponentFrom: (component) ->
      return "#{component.subtype}/template"

    # Renders an object as stringified json.
    json: (context) ->
      return JSON.stringify(context)

    # Renders a block N times
    times: (n, block) ->
      accumulator = ''
      for i in [1...n] by 1
        accumulator += block.fn(i)
      return accumulator

    # Renders the "from" to "to" elements of a collection.
    # @usage {{# range 0 1 collection }}
    # @param {int} from
    # @param {int} to
    range: (from, to, context, options) ->
      return _.map _.slice(context, from, to), (item) ->
        return options.fn?(item)
      .join('')

    # Splits an array into arrays of size 'size'.
    # @usage {{# chunk 2 collection }}
    chunk: (size, context, options) ->
      accumulator = ''
      for chunk in _.chunk context, size
        accumulator += options.fn?(chunk)
      return accumulator

    # Concatenates any number of strings.
    concat: (items..., context) ->
      aggregator = ''
      for i in items
        aggregator += i

      return aggregator

    # Get a property from the given object.
    getProperty: (context, prop) ->
      return context[prop]

    # Given the current path, get the next page path.
    nextPage: (currentPath) ->
      pathArray = currentPath.split('/').filter (i) -> i isnt ''

      # This checks to see if the last item in the path is a number.
      if isFinite(String(pathArray.slice(-1).pop()))
        pageNumber = parseInt(pathArray.pop()) + 1
      else
        pageNumber = 1

      pathArray.push(pageNumber)
      newPath = '/' + pathArray.join '/'
      return newPath

  return helpers
