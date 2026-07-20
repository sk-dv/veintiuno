Jugador = require '../models/Jugador'
Croupier = require '../models/Croupier'
Partida = require '../models/Partida'

croupier = new Croupier()
jugador = new Jugador('Sad')

partida = new Partida(croupier, jugador, false)

console.log partida.evaluarMano([
  {
    "carta": "pQ",
    "visible": true
  },
  {
    "carta": "dA",
    "visible": true
  }
])