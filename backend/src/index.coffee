path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'

clc = require 'cli-color'

green = clc.green
log = console.log

app = express()

app.use bodyParser.urlencoded({extended: true})
app.use bodyParser.json()

app.use (req, res, next) ->
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type')
  if req.method == 'OPTIONS'
    return res.sendStatus(204)
  next()

partidaRoutes = require('./routes/partida')

app.use partidaRoutes

app.use (req, res) ->
  res.status(404).send {'message': 'Ruta no encontrada'}

app.use (error, req, res, next) ->
  res.status(error.status || 500).send {'message': if error.status then error.message else 'Error interno'}

app.listen 8080
log green 'Server online in port 8080'