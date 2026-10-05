Partida = require '../models/Partida'
Jugador = require '../models/Jugador'
Croupier = require '../models/Croupier'

# One game per PIN; games never share state.
partidas = new Map()

buscarPartida = (req) ->
  partida = partidas.get(req.params.pin)
  unless partida
    error = new Error('No existe una partida con ese PIN')
    error.status = 404
    throw error
  return partida

# Wraps a handler so any error becomes a JSON response instead of a crash.
manejar = (accion) -> (req, res) ->
  try
    res.send accion(req, buscarPartida)
  catch error
    res.status(error.status || 500).send {'message': error.message}

exports.crearPartida = (req, res) ->
  nombre = String(req.body.nombre || '').trim().slice(0, 30)
  return res.status(400).send {'message': 'El nombre es obligatorio'} unless nombre

  partida = new Partida(new Croupier(), new Jugador(nombre))
  partidas.set(partida.id, partida)

  res.status(201).send {'id_partida': partida.id, 'id_jugador': partida.jugador.id}

exports.verPartida = manejar (req, buscar) ->
  buscar(req).vista()

exports.apostar = manejar (req, buscar) ->
  partida = buscar(req)
  partida.apostar(req.body.id_jugador, req.body.cantidad)
  partida.vista()

exports.pedir = manejar (req, buscar) ->
  partida = buscar(req)
  partida.pedir(req.body.id_jugador)
  partida.vista()

exports.plantarse = manejar (req, buscar) ->
  partida = buscar(req)
  partida.plantarse(req.body.id_jugador)
  partida.vista()

exports.reiniciar = manejar (req, buscar) ->
  partida = buscar(req)
  partida.reiniciar(req.body.id_jugador)
  partida.vista()
