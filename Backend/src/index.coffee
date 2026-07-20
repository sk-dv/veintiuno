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

app.listen 8080
log green 'Server online in port 8080'