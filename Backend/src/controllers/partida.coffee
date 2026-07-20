Modelo = require '../models/Modelo'
Partida = require '../models/Partida'
Jugador = require '../models/Jugador'
Croupier = require '../models/Croupier'
BD = require '../bd/Modelo'


modelo = new Modelo()
database = new BD()
partida = null

generarMazos = () ->
  {croupier} = partida

  mazo = {
    'croupier': {
      'id': croupier.id,
      'mano': croupier.mano
    }
  }

  mazo.jugador = {
    'id': partida.jugador.id,
    'mano': partida.jugador.mano
  }

  database.guardarPartida(partida)

  return mazo

exports.getModelo = (req, res) ->
  res.send modelo

exports.getIniciarPartida = (req, res) ->
  partida.repartir()
  res.send generarMazos()

exports.getEvaluarPartida = (req, res) ->
  res.send partida.evaluarPartida()

exports.getReiniciarPartida = (req, res) ->
  partida.reiniciar()
  res.send generarMazos()

exports.getTurno = (req, res) ->
  res.send partida.obtenerTurno()

exports.postCargarPartida = (req, res) ->
  dbRes = await database.cargarPartida(req.body.id)

  jugador = new Jugador(dbRes.jugador.nombre_jugador)
  croupier = new Croupier()
  partida_id = dbRes._id
  baraja = dbRes.baraja
  turno = dbRes.turno
  multijugador = (dbRes.multijugador == "true")

  croupier.id = dbRes.croupier.id
  croupier.mano = dbRes.croupier.mano

  jugador.id = dbRes.jugador.id
  jugador.mano = dbRes.jugador.mano
  jugador.cartera = dbRes.jugador.cartera
  jugadores = dbRes.jugadores

  partida = new Partida(croupier, jugador, multijugador, jugadores, baraja)

  partida.baraja = baraja
  partida.id = partida_id
  partida.turno = turno

  res.send partida

exports.postCrearPartida = (req, res) ->
  {nombre, multijugador} = req.body

  croupier = new Croupier()
  jugador = new Jugador(nombre)

  partida = new Partida(croupier, jugador, multijugador)
  modelo.push(partida)

  database.crearEsquema(partida)

  res.send {'id_partida': partida.id, 'id_jugador': jugador.id, 'multijugador': partida.multijugador}

exports.postUnirsePartida = (req, res) ->
  {idPartida, nombre} = req.body

  for partida in modelo
    if partida.id == idPartida
      nuevoJugador = new Jugador(nombre)
      partida.jugadores.push(nuevoJugador)
      partida.repartirCartasJugador(nuevoJugador)
      res.send {
        id_partida: partida.id,
        jugador: {
          id: nuevoJugador.id,
          mano: nuevoJugador.mano
        },
        croupier: partida.croupier
        jugadores: partida.jugadores
      }

exports.postEliminarJugador = (req, res) ->
  {id} = req.body
  res.send {'status': partida.eliminarJugador(id)}

exports.postAgregarJugador = (req, res) ->
  {id, nombre} = req.body

  jugador = new Jugador(nombre)

  if partida.jugadores.length <= 2
    partida = modelo.filter((partida) -> partida.id = id)[0]
    partida.agregarJugador(jugador)

  res.send if partida.jugadores.length <= 2 then {'partida': partida.id} else {'message': 'No se pueden agregar más jugadores'}

exports.postEvaluarMano = (req, res) ->
  {id} = req.body
  res.send {'valor': partida.evaluarManoJugador(id)}

exports.postApostar = (req, res) ->
  {id, cantidad} = req.body
  res.send {'credito': partida.apostar(id, cantidad)}

exports.postPedir = (req, res) ->
  {id} = req.body
  res.send {'mano': partida.pedir(id)}

