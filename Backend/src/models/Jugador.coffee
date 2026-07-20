uniqid = require 'uniqid'

class Jugador
  constructor: (@nombre) ->
    @id = uniqid()
    @mano = []
    @cartera = 100

  apostar: (apuesta) ->
    @cartera -= apuesta

  plantarse: ->

module.exports = Jugador