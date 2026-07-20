uniqid = require 'uniqid'
Carta = require './Carta'

class Partida
  constructor: (@croupier, jugador, @multijugador, @baraja) ->
    @id = uniqid()
    @olla = 0
    @turno = 0

    if @baraja == undefined
      @baraja = this.barajear()

    @jugador = jugador

    @jugadores = []

    if @multijugador
      @jugadores.push(@jugador)

  barajear: ->
    palos = ['c', 'd', 'p', 't']
    valores = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

    baraja = []

    for palo in palos
      for valor in valores
        baraja.push(palo + valor)

    return baraja.sort(() -> Math.random() - 0.5)

  agregarJugador: (jugador) ->
    if @jugadores.length > 7
      return null
    else
      @jugadores.push(jugador)
      return jugador.id

  verificarJugadores: () ->
    return @jugadores

  repartir: () ->
    if @croupier.mano < 2
      @croupier.mano.push(new Carta(@baraja.pop(), false))
      @croupier.mano.push(new Carta(@baraja.pop(), true))

      for i in [0..1]
        @jugador.mano.push(new Carta(@baraja.pop(), true))

  repartirCartasJugador: (jugador) ->
    for i in [0..1]
      jugador.mano.push(new Carta(@baraja.pop(), true))

  evaluarManoJugador: (id) ->
    console.log @croupier.id, id, @croupier.id == id

    if id == @croupier.id
      return this.evaluarMano(@croupier.mano)
    else if !@multijugador && id = @jugador.id
      return this.evaluarMano(@jugador.mano)
    else
      jugador = @jugadores.filter((jugador) -> jugador.id == id)[0]
      return this.evaluarMano(jugador.mano)

  evaluarMano: (mano) ->
    valorMano = 0

    hayUnAs = mano.filter((cartas) -> cartas.carta.substr(1, cartas.carta.length - 1) == 'A').length >= 1

    if !hayUnAs
      valorMano += this.obtenerValorNumerico(cartas.carta) for cartas in mano
      return valorMano
    else
      manoFiltrada = mano.filter (cartas) -> cartas.carta.substr(1, cartas.carta.length - 1) != 'A'
      valorMano += this.obtenerValorNumerico(mano.carta) for mano in manoFiltrada
      return if valorMano + 10 <= 21 then valorMano + 11 else valorMano + 1

  obtenerValorNumerico: (carta) ->
    valor = carta.substr(1, carta.length - 1)
    return if valor in ['J', 'Q', 'K'] then 10 else parseInt(valor)

  apostar: (id, monto) ->
    if !@multijugador && id == @jugador.id
      @jugador.apostar(monto)
      @olla += monto
      return @jugador.cartera
    else
      console.log "multijugador no implementado"

  pagarAlCasino: ()->
    @olla = 0

  pagarAlJugador: () ->
    console.log @olla, @jugador.cartera
    if !@multijugador
      @jugador.cartera += @olla * 2
      @olla = 0
    else
      console.log "multijugador no implementado"

  pedir: (id) ->
    if !@multijugador && id == @jugador.id
      @jugador.mano.push(new Carta(@baraja.pop(), true))
      return @jugador.mano

    if id == @croupier.id
      @croupier.mano.push(new Carta(@baraja.pop(), true))
      return @croupier.mano
    else
      console.log "multijugador no implementado"

  evaluarPartida: ->
    while this.evaluarMano(@croupier.mano) < 17
      this.pedir(@croupier.id)

    puntosJugador = this.evaluarMano(@jugador.mano)
    puntosCroupier = this.evaluarMano(@croupier.mano)
    ganador = ''

    this.mostrarCartas()

    if (@jugador.mano.length < 3) && (puntosJugador == 21)
      this.pagarAlJugador()
      ganador = 'jugador'

    else if puntosJugador > 21
      this.pagarAlCasino()
      ganador = 'croupier'

    else if puntosCroupier > 21
      this.pagarAlJugador()
      ganador = 'jugador'

    else if puntosCroupier == puntosJugador
      ganador = 'empate'

    else
      if puntosCroupier > puntosJugador
        this.pagarAlCasino()
        ganador = 'croupier'
      else
        this.pagarAlJugador()
        ganador = 'jugador'

    return  {
      'ganador': ganador
      'croupier': this.mostrarCartas()
      'score_croupier': this.evaluarMano(@croupier.mano)
      'score_jugador': this.evaluarMano(@jugador.mano)
      'credito': @jugador.cartera
    }

  mostrarCartas: ->
    for carta in @croupier.mano
      carta.visible = true

    return @croupier.mano

  obtenerTurno: ->
    next_id = @jugadores[@turno].id
    if @turno +1 >= jugadores.length
      @turno = 0
    else
      @turno += 1

    return next_id

  reiniciar: ->
    @baraja = this.barajear()
    @croupier.mano = []

    if !@multijugador
      @jugador.mano = []

    this.repartir()

  terminar: ->

module.exports = Partida