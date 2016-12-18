path = require 'path'
routes = require('./app/routes')

express = require('express')
handlebars = require('express-handlebars')
app = express()
port = 3000

global.site =
  staticPath: 'C://Users/ferra_000/Pictures'

app.engine '.hbs', handlebars
  defaultLayout: 'index',
  extname: '.hbs',
  layoutsDir: 'app/views/layouts',
  partialsDir: 'app/views/partials'

app.set 'view engine', '.hbs'
app.set 'views', 'app/views/pages'

app.use express.static(global.site.staticPath)
app.use express.static path.join(__dirname, 'public')

app.use routes

app.use (err, req, res, next) ->
  console.log(err)
  res.status(500).send('Something is broken!')

app.start = ->
  app.server = app.listen port, (err) ->
    if (err)
      console.log('Something went wrong.', err)
    console.log("server is listening on #{port}")

app.stop = ->
  app.server?.close()

module.exports = app